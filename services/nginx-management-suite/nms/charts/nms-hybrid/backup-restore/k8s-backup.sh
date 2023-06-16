#!/usr/bin/env bash

# Packaging:
# - delivered as part the Helm chart tarball
# - Helm chart structure will look like:
# - nms-hybrid
#   |- backup-restore
#      |- k8s-backup.sh

# NGINX Management Suite backup script version 1.0.0

echo -e "--- NGINX Management Suite k8s backup script --- \n"

# The backup script requires SQLite3 to backup the Dqlite database.
if ! cmd=$(command -v "sqlite3") || [ ! -x "$cmd" ]; then
    echo "WARNING: The backup script cannot find the SQLite binary. This binary is required to back up the Dqlite (distributed SQLite) database."
    exit 1
fi

# Associative arrays were added in Bash 4, and are not in Bash 3.2 and earlier
if ((BASH_VERSINFO[0] < 4))
then
  echo "Bash version 4 or higher is required to run this script"
  exit 1
fi

set -o pipefail

shopt -s nullglob

PACKAGE_NAME="k8s-backup-$(date +%s)"
# make assumption we are running helm from a linux-based machine
# and will have access to /tmp folder 
PACKAGE_DIR="/tmp/$PACKAGE_NAME"
NMS_HELM_NAMESPACE=""
# default is to run this script from the `support-package` sub-directory in the Chart directory

# Default values if nothing is passed to the script via arguments.
OUTPUT_DIR="$(pwd)"

SQLITE_BIN="sqlite3"
DQLITE_BACKUP_PATH="/etc/nms/scripts"
DQLITE_BACKUP_BIN="dqlite-backup"

declare -a svcs=( core dpm integrations acm )

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

copy_to_dir() {
    create_path_if_not_exists "$2"
    cp "$1"/* "$2"
}

validate_argument() {
    if [[ -z "$2" ]]; then
        echo "Argument $1 value empty"
        exit 1
    fi
}

fail_if_dir_not_exists() {
    if [[ ! -d "$1" ]]; then
        echo "Directory $1 does not exist"
        exit 1
    fi
}

print_help() {
    echo "Usage: $0 [-option value...] "
    echo "A valid kubeconfig is expected in a default location"
    echo "  -h  | --help                Print this help message"
    echo "  -o  | --output_dir          Directory where k8s-backup archive will be generated"
    echo "  -n  | --namespace           NGINX Instance Manager Helm namespace"
}

parse_args() {
    echo_section "Parse arguments: $*"

    if [[ $# -ne 0 ]]; then
        while [ "$1" != "" ]; do
            case $1 in
                -o | --output_dir )         validate_argument "$1" "$2"
                                            fail_if_dir_not_exists "$2"
                                            OUTPUT_DIR=$(sanitize_path "$2")
                                            shift
                                            ;;
                -n | --namespace )          NMS_HELM_NAMESPACE="$2"
                                            shift
                                            ;;
                -h | --help )               print_help
                                            exit 0
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

get_core_secrets(){
  local output_dir="$1"
  local core_pod_name
  local core_pod_name_with_ns

  echo "collecting core secrets"

  create_path_if_not_exists "$output_dir/core-secrets"
  core_pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep core)"
  core_pod_name_with_ns="${NMS_HELM_NAMESPACE}/${core_pod_name#"pod/"}"

  kubectl -n "${NMS_HELM_NAMESPACE}" cp -c core "$core_pod_name_with_ns":/var/lib/nms/secrets $output_dir/core-secrets

}

get_app_info() {
    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    echo_section "Collect NMS info"

    configmaps=($(kubectl -n "$NMS_HELM_NAMESPACE" get cm --no-headers -o custom-columns=":metadata.name" | grep -P '^nms-.+$'))
    secrets=($(kubectl -n "$NMS_HELM_NAMESPACE" get secret --no-headers -o custom-columns=":metadata.name" | grep -P '^nms-.+$'))

    echo "collecting k8s configmaps"
    for cm in "${configmaps[@]}"; do
        target_file="$output_dir/configmaps/$cm.json"
        create_path_if_not_exists "${target_file%/*}" || echo "Writing to $target_file failed"
        kubectl -n "$NMS_HELM_NAMESPACE" get cm $cm -o json | jq '{apiVersion: .apiVersion, data: .data, kind: .kind, metadata: {labels: .metadata.labels, name: .metadata.name, namespace: .metadata.namespace}}' > "${target_file}"
    done
    echo "collecting k8s secrets"
    for sec in "${secrets[@]}"; do
        target_file="$output_dir/secrets/$sec.json"
        create_path_if_not_exists "${target_file%/*}" || echo "Writing to $target_file failed"
        kubectl -n "$NMS_HELM_NAMESPACE" get secret $sec -o json | jq '{apiVersion: .apiVersion, data: .data, kind: .kind, type: .type, metadata: {annotations: .metadata.annotations, labels: .metadata.labels, name: .metadata.name, namespace: .metadata.namespace}}' > ${target_file}
    done

    echo "pod information collected"
}

# Dump data from dqlite database
dump_dqlite() {
    local output_dir="$1"
    local database="$2"
    local touch_nms_conf
    local nms_conf

    create_path_if_not_exists "$output_dir"

    echo_section "Dump dqlite: $database"

    case ${database} in
        "core")
        pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep core)"
        db_addr="0.0.0.0:7891"
        touch_nms_conf=false
        nms_conf="/etc/nms/nms.conf"
        ;;
        "dpm")
        pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep dpm)"
        db_addr="0.0.0.0:7890"
        touch_nms_conf=false
        nms_conf="/etc/nms/nms.conf"
        ;;
        "integrations")
        pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep integrations)"
        db_addr="0.0.0.0:7892"
        touch_nms_conf=false
        nms_conf="/etc/nms/nms.conf"
        ;;
        "acm")
        pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep acm)"
        db_addr="0.0.0.0:9300"
        # Create temp nms.conf to get platform defaults in dqlite-backup
        touch_nms_conf=true
        nms_conf="/tmp/nms.conf"
        ;;
        *)
        echo "Unknown database ${database}"
        return
    esac

    # e.g. nms/core-xyz
    pod_name_with_ns="${NMS_HELM_NAMESPACE}/${pod_name#"pod/"}"

    # run the dqlite-backup tool and copy the output files back to this host machine
    echo "nms-${database} database address is" "$db_addr"

    # verify dqlite-backup tool is available in the target container
    if ! kubectl -n "${NMS_HELM_NAMESPACE}" exec -it "${pod_name}" -- ls "${DQLITE_BACKUP_PATH}/${DQLITE_BACKUP_BIN}" > /dev/null 2>&1 /dev/null; then
      echo "WARNING: ${DQLITE_BACKUP_PATH}/${DQLITE_BACKUP_BIN} is not available in ${pod_name}. Skipping..."
      return
    fi

    echo "Collecting nms-${database} DQlite information..."
    if [ "$touch_nms_conf" = "true" ]; then
      kubectl -n "${NMS_HELM_NAMESPACE}" exec "${pod_name}" -- /bin/bash -c "touch ${nms_conf}"
    fi

    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${pod_name}" -- "${DQLITE_BACKUP_PATH}/${DQLITE_BACKUP_BIN}" -name "$database" -config "${nms_conf}" -address "$db_addr" -output "${DQLITE_BACKUP_PATH}"

    if [ "$touch_nms_conf" = "true" ]; then
      kubectl -n "${NMS_HELM_NAMESPACE}" exec "${pod_name}" -- /bin/bash -c "rm ${nms_conf}"
    fi

    # copy file back to host machine
    # shellcheck disable=SC2086
    kubectl -n "${NMS_HELM_NAMESPACE}" cp -c "${database}" "$pod_name_with_ns":${DQLITE_BACKUP_PATH}/${database} $output_dir/${database}
    # shellcheck disable=SC2086
    kubectl -n "${NMS_HELM_NAMESPACE}" cp -c "${database}" "$pod_name_with_ns":${DQLITE_BACKUP_PATH}/${database}-wal $output_dir/${database}-wal

    # delete dqlite-backup files from the container
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${pod_name}" -- rm "${DQLITE_BACKUP_PATH}/${database}"
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${pod_name}" -- rm "${DQLITE_BACKUP_PATH}/${database}-wal"

    echo "nms-${database} DQlite information collected"

    convert_dqlite_backup_to_sql "$database" "$output_dir"
}

# Converts dqlite dump
convert_dqlite_backup_to_sql() {
    if ! cmd=$(command -v "${SQLITE_BIN}") || [ ! -x "$cmd" ]; then
      echo "WARNING: cannot find ${SQLITE_BIN} binary. Skipping..."
      return
    fi

    local process="$1"
    local output_dir="$2"

    echo "converting DQlite dump to sql"
    echo "output_dir ${output_dir}"
    "${SQLITE_BIN}" "${output_dir}/${process}" .dump > "${output_dir}/${process}.sql"
    echo "nms-${process} conversion DQlite to sql complete"
    echo "removing temporary files..."
    rm "${output_dir}/${process}"
    echo "cleanup complete"
}

verify_pre_reqs() {
    if ! command -v kubectl > /dev/null; then
      echo "Error: kubectl executable not found. Cannot proceed."
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

check_module_pod_running(){
  local prefix="$1"
  if ! kubectl -n "$NMS_HELM_NAMESPACE" get pod --no-headers -o custom-columns=":metadata.name" | grep -P "^${prefix}-.+$" > /dev/null; then
    return 1
  else
    return 0
  fi
}

main() {
    prompt_for_helm_install_info

    verify_namespace_accessible

    # Application
    get_app_info "$PACKAGE_DIR"

    get_core_secrets "$PACKAGE_DIR"

    for svc in "${svcs[@]}"
    do
      if check_module_pod_running "$svc"; then
        dump_dqlite "$PACKAGE_DIR/dqlite/$svc" "$svc"
      else
        echo "$svc module pod is not running, "$svc" module database backup skipped."
      fi
    done

    ##  Back up App Delivery Manager
    # Uncomment the following lines to back up App Delivery Manager.
    # export PACKAGE_DIR NMS_HELM_NAMESPACE
    #./k8s-backup-adm.sh

}

# Verify pre-requisites and abort if any not met
verify_pre_reqs

parse_args "$@"
echo "Using tmp directory: $PACKAGE_DIR"
create_path_if_not_exists "$PACKAGE_DIR"
# Call main() in a subshell and capture stdout/stderr in a file to be included
# in the backup.
(
    main
) 2>&1 | tee "$PACKAGE_DIR/k8s-backup.log"

echo_section "Package output"
archive_file="$OUTPUT_DIR/$PACKAGE_NAME.tar.gz"
tar -C "/tmp" -czf "$archive_file" "$PACKAGE_NAME"
echo "Archive $archive_file ready"

rm -rf "$PACKAGE_DIR"

shopt -u nullglob
