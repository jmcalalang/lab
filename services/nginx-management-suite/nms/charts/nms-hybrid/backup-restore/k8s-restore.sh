#!/usr/bin/env bash

# Packaging:
# - delivered as part the Helm chart tarball
# - Helm chart structure will look like:
# - nms-hybrid
#   |- backup-restore
#      |- k8s-restore.sh

echo -e "--- NGINX Management Suite k8s restore script --- \n"

DATE=$(date +"%Y%m%d%H%M")
PACKAGE_NAME="k8s-restore-${DATE}"
DEFAULT_PLATFORM_CONFIG="/etc/nms/nms.conf"

export RESTORE_DIR="/tmp/nms-restore-${DATE}"

mkdir -p "${RESTORE_DIR}"

set -o pipefail

shopt -s nullglob

NMS_HELM_NAMESPACE=""
# default is to run this script from the `support-package` sub-directory in the Chart directory

# Default values if nothing is passed to the script via arguments.
OUTPUT_DIR="$(pwd)"

DQLITE_RESTORE_PATH="/etc/nms/scripts"
DQLITE_RESTORE_BIN="dqlite-restore"
DQLITE_DB_PATH="/var/lib/nms/dqlite"

restore="false"
data_only="false"

echo_section() {
    echo "####"
    echo "#### $*"
    echo "####"
}

sanitize_path() {
    # Remove trailing slashes
    echo "${1%/}"
}

create_path_if_not_exists() {
    if [[ ! -d "$1" ]]; then
        echo "Creating dirs: $1"
        mkdir -p "$1"
    fi
}

validate_argument() {
    if [[ -z "$2" ]]; then
        echo "Argument $1 value empty"
        exit 1
    fi
}

print_help() {
    echo "Usage: $0 [-option value...] "
    echo "A valid kubeconfig is expected in a default location"
    echo "  -h  | --help                Print this help message"
    echo "  -i  | --input               Full file path to backup archive"
    echo "  -n  | --namespace           NGINX Instance Manager Helm namespace"
    echo "  -r  | --run                 Perform the restoration"
    echo "  -d  | --data-only           Exclude configuration information from the restoration"
}

parse_args() {
    echo_section "Parse arguments: $*"

    if [[ $# -ne 0 ]]; then
        while [ "$1" != "" ]; do
            case $1 in
                -i | --input )              validate_argument "$1" "$2"
                                            BACKUP_FILE=$(sanitize_path "$2")
                                            shift
                                            ;;
                -n | --namespace )          NMS_HELM_NAMESPACE="$2"
                                            shift
                                            ;;
                -h | --help )               print_help
                                            exit 0
                                            ;;
                -r | --run )                restore="true"
                                            ;;
                -d | --data )               data_only="true"
                                            ;;
                * )                         echo "Invalid argument: $1"
                                            print_help
                                            exit 1
            esac
            shift
        done
    fi

}

prompt_for_helm_install_info() {
    echo_section "Query user for info"
    if [ -z "$NMS_HELM_NAMESPACE" ]; then
        echo "Please provide the NGINX Instance Manager Helm namespace:"
        read -r NMS_HELM_NAMESPACE
    fi
}

verify_pre_reqs() {
    # We require running in the 'backup-restore' sub-directory of the Chart directory
    if ! command -v kubectl > /dev/null; then
      echo "Error: kubectl executable not found. Cannot proceed."
      exit 1
    fi

    # Associative arrays were added in Bash 4, and are not in Bash 3.2 and earlier
    if ((BASH_VERSINFO[0] < 4))
    then
      echo "Bash version 4 or higher is required to run this script"
      exit 1
    fi

    if ! command -v jq > /dev/null; then
      echo "Error: jq executable not found. Cannot proceed."
      exit 1
    fi
}

verify_namespace_accessible() {
    if ! kubectl get ns "$NMS_HELM_NAMESPACE" > /dev/null; then
      echo "Error: could not get provided Kubernetes namespace $NMS_HELM_NAMESPACE. Please confirm this is correct namespace and that appropriate permissions are granted."
      exit 1
    fi
}

restore_config(){
  local backup_dir=$1
  local filename

  echo_section "Restoring configurations"

  for cm in $backup_dir/configmaps/*;
  do
    filename=$(basename -- "$cm")
    kubectl -n "${NAMESPACE}" delete cm "${filename%.*}" --wait=true --ignore-not-found=true
    if ! kubectl -n "${NAMESPACE}" apply -f "$cm" 2>&1; then
        echo "Failed to load configmap ${cm}"
        exit 1
    else
      echo "Configmap ${cm} successfully loaded"
    fi
  done
  echo "k8s configmaps successfully loaded."

  for sec in $backup_dir/secrets/*;
  do
      filename=$(basename -- "$cm")
      kubectl -n "${NAMESPACE}" delete secret "${filename%.*}" --wait=true --ignore-not-found=true
      if ! kubectl -n "${NAMESPACE}" apply -f "$sec" 2>&1; then
          echo "Failed to load secret ${sec}"
          exit 1
      fi
  done
  echo "k8s secrets successfully loaded."
}

restore_core_secrets(){
    local backup_dir="$1"
    local utility_pod_name="$2"
    local utility_pod_name_with_ns

    if ! pvc_exists "core-secrets"; then
      echo "local storage for core-secrets detected, restoration is not supported, skipping"
      return
    fi

    echo_section "Restoring Core Secrets"
    utility_pod_name_with_ns="${NMS_HELM_NAMESPACE}/${utility_pod_name#"pod/"}"
    # Remove old secrets directory
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${utility_pod_name}" -- sh -c 'rm -rf /var/lib/nms/secrets/*'
    # Copy secrets from backup to /var/lib/nms/secrets
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${utility_pod_name}" -- mkdir "/tmp/core-secrets"
    kubectl -n "${NMS_HELM_NAMESPACE}" cp -c utility "$backup_dir/core-secrets" "$utility_pod_name_with_ns":/tmp
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${utility_pod_name}" -- sh -c 'cp -r /tmp/core-secrets/* /var/lib/nms/secrets'
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${utility_pod_name}" -- rm -r "/tmp/core-secrets"
    echo "core secrets restored"
}

pvc_exists(){
  local database=$1
  local pvc_claim_name

  pvc_claim_name=$(kubectl -n "${NMS_HELM_NAMESPACE}" get pvc -o name | grep "$database")
  if [ "${pvc_claim_name}" = "" ]; then
    return 1
  fi
  return 0
}

restore_db() {
    local backup_dir="$1"
    local database="$2"
    local utility_pod_name="$3"

    if ! pvc_exists ${database}; then
      echo "local storage for ${database} database detected, database restoration is not supported, skipping"
      return
    fi

    if ! kubectl -n "${NMS_HELM_NAMESPACE}" get deployment/utility -o json | jq -r '.spec.template.spec.volumes' | grep "${database}-dqlite-volume" 2>&1 > /dev/null; then
      echo "database volume for ${database} not added to utility pod, database restoration is not supported, skipping"
      return
    fi

    echo "restoring nms-${database} database"

    utility_pod_name_with_ns="${NMS_HELM_NAMESPACE}/${utility_pod_name#"pod/"}"

    case ${database} in
        "core")
        db_addr="0.0.0.0:7891"
        ;;
        "dpm")
        db_addr="0.0.0.0:7890"
        ;;
        "integrations")
        db_addr="0.0.0.0:7892"
        ;;
        "acm")
        db_addr="127.0.0.1:9300"
        ;;
        *)
        echo "Unknown database ${database}"
        return
    esac

    # copy sql backup file to restore directory inside container
    # shellcheck disable=SC2086
    kubectl -n "${NMS_HELM_NAMESPACE}" cp "${backup_dir}/${database}/${database}.sql" "$utility_pod_name_with_ns":${RESTORE_DIR}
    # Remove old database directory
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${utility_pod_name}" -- rm -r "${DQLITE_DB_PATH}/${database}/${database}"
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${utility_pod_name}" -- mkdir "${DQLITE_DB_PATH}/${database}/${database}"

    # run database restoration
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${utility_pod_name}" -- "${DQLITE_RESTORE_PATH}/${DQLITE_RESTORE_BIN}" -db-name "$database" -db-path "${DQLITE_DB_PATH}/${database}/${database}" -address "$db_addr" -backup-file-path "${RESTORE_DIR}/${database}.sql"

    # delete dqlite-restore sql file from the container
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${utility_pod_name}" -- rm -f "${RESTORE_DIR}/${database}.sql"

    echo "nms-${database} DQlite restored"
}

restore_persisted_data(){
    local package_dir=$1
    local backup_dir=$1/dqlite
    local utility_deployment_name
    local utility_pod_name
    local pod_name
    local dirs
    local svcs
    local timeout=120

    utility_deployment_name=$(kubectl -n "${NMS_HELM_NAMESPACE}" get deployment -o name | grep utility)
    if [ "${utility_deployment_name}" = "" ]; then
      echo "utility deployment not present, skipping persisted data restoration"
      return
    fi

    echo_section "Restoring persisted data"
    dirs=($(find "$backup_dir" -mindepth 1 -maxdepth 1 -type d -exec basename \{} \; 2>/dev/null))
    sqlite_dirs=($(find "$package_dir/sqlite" -mindepth 1 -maxdepth 1 -type d -exec basename \{} \; 2>/dev/null))

    echo_section "Stopping NMS service pods"
    for db in "${dirs[@]}"; do
      # Scale down target service pod
      kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/$db --replicas=0
      pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep $db)"
      kubectl -n "${NMS_HELM_NAMESPACE}" wait --for=delete $pod_name --timeout="${timeout}s"
    done
    for db in "${sqlite_dirs[@]}"; do
      # Scale down target service pod
      kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/$db --replicas=0
      pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep $db)"
      kubectl -n "${NMS_HELM_NAMESPACE}" wait --for=delete $pod_name --timeout="${timeout}s"
    done
    kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/apigw --replicas=0
    kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/ingestion --replicas=0

    echo_section "Starting NMS utility pod"
    kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/utility --replicas=1
    SECONDS=0
    until kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep utility 2>&1 > /dev/null
    do
      if (( SECONDS > timeout ))
      then
         echo "Error: utility pod has not started"
         exit 1
      fi
      sleep 5
      echo "waiting for utility pod to start"
    done
    utility_pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep utility)"
    kubectl -n "${NMS_HELM_NAMESPACE}" wait --for=condition=Ready=true "$utility_pod_name" --timeout="${timeout}s"

    # verify dqlite-restore tool is available in the target utility container
    if ! kubectl -n "${NMS_HELM_NAMESPACE}" exec -it "${utility_pod_name}" -- ls "${DQLITE_RESTORE_PATH}/${DQLITE_RESTORE_BIN}" > /dev/null 2>&1 /dev/null; then
      echo "WARNING: ${DQLITE_RESTORE_PATH}/${DQLITE_RESTORE_BIN} is not available in ${utility_pod_name}. Skipping..."
      exit 1
    fi

    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${utility_pod_name}" -- mkdir -p "${RESTORE_DIR}"

    ## Restore the App Delivery Manager database.
    # Uncomment the following line to restore App Delivery Manager.
    # export NMS_HELM_NAMESPACE
    #./k8s-restore-adm.sh

    for db in "${dirs[@]}"; do
      if [[ "${db}" != *"adm"* ]]; then
        restore_db "$backup_dir" "$db" "$utility_pod_name"
      fi
    done

    restore_core_secrets "${package_dir}" "$utility_pod_name"

    echo_section "Stopping NMS utility pod"
    kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/utility --replicas=0
    kubectl -n "${NMS_HELM_NAMESPACE}" wait --for=delete $utility_pod_name --timeout="${timeout}s"

    echo_section "Starting NMS service pods"
    for db in "${dirs[@]}"; do
      kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/$db --replicas=1
    done
    for db in "${sqlite_dirs[@]}"; do
      kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/$db --replicas=1
    done
    kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/apigw --replicas=1
    kubectl -n "${NMS_HELM_NAMESPACE}" scale deployment/ingestion --replicas=1
}

main() {
    prompt_for_helm_install_info

    verify_namespace_accessible

    echo "Extract the backup file to a temporary directory."
    echo "Extracting \"${BACKUP_FILE}\" into \"${RESTORE_DIR}\""
    tar -zxf "${BACKUP_FILE}" -C "${RESTORE_DIR}" --strip-components 1

    if [ "$data_only" != "true" ]; then
      restore_config "${RESTORE_DIR}"
    fi
    restore_persisted_data "${RESTORE_DIR}"
}

if [ "$EUID" -ne 0 ]
    then echo "Please run $0 script as root"
    exit 1
fi

# Verify pre-requisites and abort if any not met
verify_pre_reqs
parse_args "$@"

if [ "$restore" != "true" ]; then
  print_help
  exit 0
fi


if [ "${BACKUP_FILE}" = "" ]; then
  echo "Error: a backup archive is required"
  print_help
  exit 1
fi

echo -e " --- Will restore from backup file in 5 seconds --- "
echo -e " --- Press Ctrl-C to cancel ---\n"
sleep 5

echo "Using tmp directory: $RESTORE_DIR"
create_path_if_not_exists "$RESTORE_DIR"
# Call main() in a subshell and capture stdout/stderr in a file to be included
# in the backup.
(
    main
) 2>&1 | tee "${PWD}/k8s-restore.log"

rm -rf "$RESTORE_DIR"

shopt -u nullglob
