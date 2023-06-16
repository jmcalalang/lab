#!/usr/bin/env bash

# Packaging:
# - delivered as part the Helm chart tarball
# - Helm chart structure will look like:
# - nms-hybrid 
#   |- Chart.yaml
#   |- files
#   |- generated
#   |- templates
#   |- values.schema.json
#   |- values.yaml
#   |- support-package
#      |- k8s-support-package.sh

# Associative arrays were added in Bash 4, and are not in Bash 3.2 and earlier
if ((BASH_VERSINFO[0] < 4))
then
  echo "Bash version 4 or higher is required to run this script"
  exit 1
fi

set -o pipefail

shopt -s nullglob

PACKAGE_NAME="k8s-support-pkg-$(date +%s)"
# make assumption we are running helm from a linux-based machine
# and will have access to /tmp folder 
PACKAGE_DIR="/tmp/$PACKAGE_NAME"
NMS_HELM_NAMESPACE=""
NMS_MODULES=""
# default is to run this script from the `support-package` sub-directory in the Chart directory
CHART_DIR=".."
CHART_FILE="${CHART_DIR}/Chart.yaml"
# Default values if nothing is passed to the script via arguments.
OUTPUT_DIR="$(pwd)"

EXCLUDE_DB_DATA=false
EXCLUDE_TS_DATA=false

SQLITE_BIN="sqlite3"
DQLITE_BACKUP_PATH="/etc/nms/scripts"
DQLITE_BACKUP_BIN="dqlite-backup"

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
    echo "  -o  | --output_dir          Directory where k8s-support-pkg archive will be generated"
    echo "  -n  | --namespace           NGINX Instance Manager Helm namespace"
    echo "  -xd | --exclude_databases   exclude all database data dumps from the support package"
    echo "  -xt | --exclude_timeseries  exclude timeseries data dumps from the support package"
    echo "  -m  | --modules             include specific modules in Dqlite database backup data"
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
                -xd | --exclude_databases ) EXCLUDE_DB_DATA=true
                                            ;;
                -xt | --exclude_timeseries )EXCLUDE_TS_DATA=true
                                            ;;
                -m | --modules )            NMS_MODULES="$2"
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

get_chart_files() {
    echo_section "Collect Helm Chart files"
    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    rsync -rv --exclude='support-package' "${CHART_DIR}/" "$output_dir"
}

get_cluster_info() {
    echo_section "Collect Kubernetes cluster info"
    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    declare -A CLUSTER_INFO_COMMANDS
    CLUSTER_INFO_COMMANDS=(
        ["cluster-info"]="kubectl cluster-info dump"
        ["cluster-info-yaml"]="kubectl cluster-info dump -o yaml"
        ["version-yaml"]="kubectl version -o yaml"
        ["get-nodes"]="kubectl get nodes"
        ["get-nodes-yaml"]="kubectl get nodes -o yaml"
        ["get-nodes-wide"]="kubectl get nodes -o wide"
        ["describe-nodes"]="kubectl describe nodes"
        ["get-sc"]="kubectl get sc"
        ["get-sc-yaml"]="kubectl get sc -o yaml"
        ["describe-sc"]="kubectl describe sc"
    )

    for cmd_key in "${!CLUSTER_INFO_COMMANDS[@]}"; do        
        cmd="${CLUSTER_INFO_COMMANDS[$cmd_key]}"

        if [[ $cmd_key == *-yaml ]]; then
            target_file="$output_dir/$cmd_key.yaml"
        else
            target_file="$output_dir/$cmd_key.txt"
        fi
        create_path_if_not_exists "${target_file%/*}" && touch "$target_file" || echo "Writing to $target_file failed"
        
        echo "Running $cmd"
        $cmd > "${target_file}" 2>&1
    done
}

get_ns_info() {
    echo_section "Collect ${NMS_HELM_NAMESPACE} namespace info"
    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    declare -A NS_INFO_COMMANDS
    NS_INFO_COMMANDS=(
        ["describe-ns"]="kubectl describe namespace ${NMS_HELM_NAMESPACE}"
        ["get-events"]="kubectl -n ${NMS_HELM_NAMESPACE} get events"
        ["get-events-yaml"]="kubectl -n ${NMS_HELM_NAMESPACE} get events -o yaml"
        ["api-versions"]="kubectl -n ${NMS_HELM_NAMESPACE} api-versions"
        ["get-apiservice"]="kubectl -n ${NMS_HELM_NAMESPACE} get apiservice"
        ["get-apiservice-yaml"]="kubectl -n ${NMS_HELM_NAMESPACE} get apiservice -o yaml"
    )

    for cmd_key in "${!NS_INFO_COMMANDS[@]}"; do        
        cmd="${NS_INFO_COMMANDS[$cmd_key]}"

        if [[ $cmd_key == *-yaml ]]; then
            target_file="$output_dir/$cmd_key.yaml"
        else
            target_file="$output_dir/$cmd_key.txt"
        fi
        create_path_if_not_exists "${target_file%/*}" && touch "$target_file" || echo "Writing to $target_file failed"
        
        echo "Running $cmd"
        $cmd > "${target_file}" 2>&1
    done    
}

get_ns_resources() {
    echo_section "Collect resources under ${NMS_HELM_NAMESPACE} namespace"
    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    target_file="$output_dir/ns-resources.txt"
    
    for r in $(kubectl -n "${NMS_HELM_NAMESPACE}" api-resources --verbs=list --namespaced -o name 2>/dev/null); do
        kubectl_cmd="kubectl -n ${NMS_HELM_NAMESPACE} get $r --show-kind=true -o wide"
        echo "Running $kubectl_cmd"
        if res=$(${kubectl_cmd} 2>&1) && [ -n "$res" ]; then
            printf "%b\n\n" "$res" >>"$target_file"
        fi
    done
}

get_app_info() {
    echo_section "Collect NMS info"
    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    declare -A APP_INFO_COMMANDS
    APP_INFO_COMMANDS=(
        ["get-deployments"]="kubectl -n ${NMS_HELM_NAMESPACE} get deployments"
        ["get-deployments-yaml"]="kubectl -n ${NMS_HELM_NAMESPACE} get deployments -o yaml"
        ["describe-deployments"]="kubectl -n ${NMS_HELM_NAMESPACE} describe deployments"
        ["get-services"]="kubectl -n ${NMS_HELM_NAMESPACE} get services"
        ["get-services-yaml"]="kubectl -n ${NMS_HELM_NAMESPACE} get services -o yaml"
        ["describe-services"]="kubectl -n ${NMS_HELM_NAMESPACE} describe services"
        ["get-pv"]="kubectl -n ${NMS_HELM_NAMESPACE} get pv"
        ["get-pv-yaml"]="kubectl -n ${NMS_HELM_NAMESPACE} get pv -o yaml"
        ["describe-pv"]="kubectl -n ${NMS_HELM_NAMESPACE} describe pv"
        ["get-pvc"]="kubectl -n ${NMS_HELM_NAMESPACE} get pvc"
        ["get-pvc-yaml"]="kubectl -n ${NMS_HELM_NAMESPACE} get pvc -o yaml"
        ["describe-pvc"]="kubectl -n ${NMS_HELM_NAMESPACE} describe pvc"
        ["get-secrets"]="kubectl -n ${NMS_HELM_NAMESPACE} get secrets"
        ["get-secrets-yaml"]="kubectl -n ${NMS_HELM_NAMESPACE} get secrets -o yaml"
        ["describe-secrets"]="kubectl -n ${NMS_HELM_NAMESPACE} describe secrets"
        ["get-configmaps"]="kubectl -n ${NMS_HELM_NAMESPACE} get configmaps"
        ["get-configmaps-yaml"]="kubectl -n ${NMS_HELM_NAMESPACE} get configmaps -o yaml"
        ["describe-configmaps"]="kubectl -n ${NMS_HELM_NAMESPACE} describe configmaps"
        ["get-pods"]="kubectl -n ${NMS_HELM_NAMESPACE} get pods"
        ["get-pods-yaml"]="kubectl -n ${NMS_HELM_NAMESPACE} get pods -o yaml"
        ["get-pods-wide"]="kubectl -n ${NMS_HELM_NAMESPACE} get pods -o wide"
        ["describe-pods"]="kubectl -n ${NMS_HELM_NAMESPACE} describe pods"
    )

    for cmd_key in "${!APP_INFO_COMMANDS[@]}"; do
        cmd="${APP_INFO_COMMANDS[$cmd_key]}"

        if [[ $cmd_key == *-yaml ]]; then
            target_file="$output_dir/$cmd_key.yaml"
        else
            target_file="$output_dir/$cmd_key.txt"
        fi
        create_path_if_not_exists "${target_file%/*}" && touch "$target_file" || echo "Writing to $target_file failed"
        
        echo "Running $cmd"
        $cmd > "${target_file}" 2>&1
    done

    echo "pod information collected"
}

get_pod_logs() {
    echo_section "Collect pod logs"
    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    for p in $(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name 2>/dev/null); do
        kubectl_cmd="kubectl -n ${NMS_HELM_NAMESPACE} logs $p"
        echo "Running $kubectl_cmd"
        if res=$(${kubectl_cmd} 2>&1) && [ -n "$res" ]; then
            target_file="$output_dir/${p#"pod/"}-logs.txt"
            printf "%b\n\n" "$res" >"$target_file"
        fi
        # Gather logs for any crashed pods
        kubectl_cmd="kubectl -n ${NMS_HELM_NAMESPACE} logs $p --previous"
        echo "Running $kubectl_cmd"
        if res=$(${kubectl_cmd} 2>&1) && [ -n "$res" ]; then
            target_file="$output_dir/${p#"pod/"}-logs-previous.txt"
            printf "%b\n\n" "$res" >"$target_file"
        fi
    done
}

get_pod_system_info() {
    echo_section "Collect system information"
    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    declare -A SYS_COMMANDS
    SYS_COMMANDS=(
        ["uname"]="uname -a"
        ["release"]="cat /etc/os-release"
        ["ps-faux"]="ps faux"
        ["env"]="env"
    )

    for cmd_key in "${!SYS_COMMANDS[@]}"; do
        cmd=${SYS_COMMANDS[$cmd_key]}
        for p in $(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name 2>/dev/null); do
            kubectl_cmd="kubectl -n ${NMS_HELM_NAMESPACE} exec $p -- $cmd"
            echo "Running $kubectl_cmd"
            if res=$(${kubectl_cmd} 2>&1) && [ -n "$res" ]; then
                target_file="$output_dir/${p#"pod/"}-$cmd_key.txt"
                printf "%b\n\n" "$res" >"$target_file"
            fi
        done
    done
}

get_version_info() {
    echo_section "Collect version info"
    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    local apigw_pod=""
    apigw_pod=$(kubectl -n "${NMS_HELM_NAMESPACE}" get pod -o name | grep apigw)
    local ch_pod=""
    ch_pod=$(kubectl -n "${NMS_HELM_NAMESPACE}" get pod -o name | grep clickhouse)

    declare -A NMS_VER_COMMANDS
    NMS_VER_COMMANDS=(
        ["kubectl_ver"]="kubectl version -o yaml"
        ["helm_ver"]="helm version"
        ["chart_ver"]="cat ${CHART_FILE}"
        ["apigw_ver"]="kubectl -n ${NMS_HELM_NAMESPACE} exec ${apigw_pod} -- nginx -v"
        ["clickhouse_ver"]="kubectl -n ${NMS_HELM_NAMESPACE} exec ${ch_pod} -- clickhouse-server --version"
    )

    for cmd_key in "${!NMS_VER_COMMANDS[@]}"; do
        cmd=${NMS_VER_COMMANDS[$cmd_key]}
        echo "Running command: [${cmd}]"
        # nginx prints its version info to stderr by design
        # so redirect stderr to same output to capture nginx version info
        # do this for all commands just to keep the code simple
        $cmd > "${output_dir}/$cmd_key.txt" 2>&1
    done
}

# check if the clickhouse pod is in the Running state
is_ch_running() {
    local ch_pod=""
    ch_pod=$(kubectl -n "${NMS_HELM_NAMESPACE}" get pod -o name | grep clickhouse)
    if [ "$(kubectl -n "${NMS_HELM_NAMESPACE}" get "$ch_pod" -o jsonpath="{.status.phase}")" == "Running" ]; then 
        return 0
    fi 
    return 1
}

# Dump timeseries data from clickhouse database 
dump_clickhouse() {
    echo_section "Collect ClickHouse information"
    local max_log_limit=50000            #Max number of logs per table
    local max_num_days=30                #Max number of days from the current day (safeguard)
    local default_hrs=12                 #Default Number of Hours to collect is it is not specified

    local output_dir="$1"
    create_path_if_not_exists "$output_dir"

    declare -A CH_COMMANDS
    CH_COMMANDS=(
        ["events.csv"]="SELECT * FROM nms.v_events WHERE creation_time > subtractHours(now(),${default_hrs}) ORDER BY creation_time DESC LIMIT ${max_log_limit} FORMAT CSVWithNames"
        ["metrics.csv"]="SELECT * FROM nms.metrics WHERE timestamp > subtractHours(now(),${default_hrs}) AND date > toDate(subtractDays(now(),${max_num_days})) ORDER BY timestamp DESC LIMIT ${max_log_limit} FORMAT CSVWithNames"
        ["metrics_1day.csv"]="SELECT * FROM nms.metrics_1day WHERE timestamp > subtractHours(now(),${default_hrs}) AND date > toDate(subtractDays(now(),${max_num_days})) ORDER BY timestamp DESC LIMIT ${max_log_limit} FORMAT CSVWithNames"
        ["metrics_1hour.csv"]="SELECT * FROM nms.metrics_1hour WHERE timestamp > subtractHours(now(),${default_hrs}) AND date > toDate(subtractDays(now(),${max_num_days})) ORDER BY timestamp DESC LIMIT ${max_log_limit} FORMAT CSVWithNames"
        ["metrics_5min.csv"]="SELECT * FROM nms.metrics_5min WHERE timestamp > subtractHours(now(),${default_hrs}) AND date > toDate(subtractDays(now(),${max_num_days})) ORDER BY timestamp DESC LIMIT ${max_log_limit} FORMAT CSVWithNames"
        ["security_events.csv"]="SELECT * FROM nms.security_events LIMIT ${max_log_limit} FORMAT CSVWithNames;"

        ["metrics-row-counts.csv"]="SELECT count(*), source FROM nms.metrics GROUP BY source FORMAT CSVWithNames"
        ["view-events-row-counts.csv"]="SELECT count(*), category FROM nms.v_events GROUP BY category FORMAT CSVWithNames"

        ["events.sql"]="SHOW CREATE TABLE nms.events"
        ["metrics.sql"]="SHOW CREATE TABLE nms.metrics"
        ["metrics_1day.sql"]="SHOW CREATE TABLE nms.metrics_1day"
        ["metrics_1hour.sql"]="SHOW CREATE TABLE nms.metrics_1hour"
        ["metrics_5min.sql"]="SHOW CREATE TABLE nms.metrics_5min"
        ["security_events.sql"]="SHOW CREATE TABLE nms.security_events;"
        ["audit_events.sql"]="SHOW CREATE TABLE nms.audit_events;"
        ["view_events.sql"]="SHOW CREATE TABLE nms.v_events;"

        ["table-sizes.stat"]="SELECT table, formatReadableSize(sum(bytes)) as size, min(min_date) as min_date, max(max_date) as max_date FROM system.parts WHERE active GROUP BY table ORDER BY table FORMAT CSVWithNames"
        ["system-asynchronous-metrics.stat"]="SELECT * FROM system.asynchronous_metrics FORMAT CSVWithNames"
        ["system-tables.stat"]="SELECT * FROM system.tables FORMAT CSVWithNames"
        ["system-parts.stat"]="SELECT * FROM system.parts ORDER BY table ASC, name DESC, modification_time DESC FORMAT CSVWithNames"
        ["system-metrics.stat"]="SELECT * FROM system.metrics FORMAT CSVWithNames"
        ["system-settings.stat"]="SELECT * FROM system.settings FORMAT CSVWithNames"
        ["system-query-log.csv"]="SELECT * FROM system.query_log WHERE event_time > subtractHours(now(),${default_hrs}) AND event_date > toDate(subtractDays(now(),${max_num_days})) ORDER BY event_time DESC LIMIT ${max_log_limit} FORMAT CSVWithNames"
        ["system-events.stat"]="SELECT * FROM system.events ORDER BY value DESC LIMIT ${max_log_limit} FORMAT CSVWithNames"

        ["metrics-profile-15-min.csv"]="SELECT hex(SHA256(instance)) inst, name, toStartOfInterval(timestamp, INTERVAL 15 minute) tmstp, count(*) cnt FROM metrics where timestamp > date_add(month, -1, timestamp) GROUP BY tmstp, inst, name ORDER BY inst, name, tmstp asc LIMIT 1000000;"
        ["metrics-profile-1-hour.csv"]="SELECT hex(SHA256(instance)) inst, name, toStartOfInterval(timestamp, INTERVAL 1 hour) tmstp, count(*) cnt FROM metrics where timestamp > date_add(month, -1, timestamp) GROUP BY tmstp, inst, name ORDER BY inst, name, tmstp asc LIMIT 1000000;"
        ["metrics-profile-1-day.csv"]="SELECT hex(SHA256(instance)) inst, name, toStartOfInterval(timestamp, INTERVAL 1 day) tmstp, count(*) cnt FROM metrics where timestamp > date_add(month, -1, timestamp) GROUP BY tmstp, inst, name ORDER BY inst, name, tmstp asc LIMIT 1000000;"
        ["metrics_5min-profile-1-hour.csv"]="SELECT hex(SHA256(instance)) inst, name, toStartOfInterval(timestamp, INTERVAL 1 hour) tmstp, count(*) cnt FROM metrics_5min where timestamp > date_add(month, -1, timestamp) GROUP BY tmstp, inst, name ORDER BY inst, name, tmstp asc LIMIT 1000000;"
        ["metrics_5min-profile-1-day.csv"]="SELECT hex(SHA256(instance)) inst, name, toStartOfInterval(timestamp, INTERVAL 1 day) tmstp, count(*) cnt FROM metrics_5min where timestamp > date_add(month, -1, timestamp) GROUP BY tmstp, inst, name ORDER BY inst, name, tmstp asc LIMIT 1000000;"
        ["metrics_1hour-profile-1-day.csv"]="SELECT hex(SHA256(instance)) inst, name, toStartOfInterval(timestamp, INTERVAL 1 day) tmstp, count(*) cnt FROM metrics_1hour where timestamp > date_add(month, -1, timestamp) GROUP BY tmstp, inst, name ORDER BY inst, name, tmstp asc LIMIT 1000000;"
        ["metrics_1hour-profile-1-month.csv"]="SELECT hex(SHA256(instance)) inst, name, toStartOfInterval(timestamp, INTERVAL 1 month) tmstp, count(*) cnt FROM metrics_1hour where timestamp > date_add(month, -1, timestamp) GROUP BY tmstp, inst, name ORDER BY inst, name, tmstp asc LIMIT 1000000;"
        ["metrics_1day-profile-1-day.csv"]="SELECT hex(SHA256(instance)) inst, name, toStartOfInterval(timestamp, INTERVAL 1 day) tmstp, count(*) cnt FROM metrics_1day where timestamp > date_add(month, -1, timestamp) GROUP BY tmstp, inst, name ORDER BY inst, name, tmstp asc LIMIT 1000000;"
        ["metrics_1day-profile-1-month.csv"]="SELECT hex(SHA256(instance)) inst, name, toStartOfInterval(timestamp, INTERVAL 1 month) tmstp, count(*) cnt FROM metrics_1day where timestamp > date_add(month, -1, timestamp) GROUP BY tmstp, inst, name ORDER BY inst, name, tmstp asc LIMIT 1000000;"
    )

    local ch_pod=""
    ch_pod=$(kubectl -n "${NMS_HELM_NAMESPACE}" get pod -o name | grep clickhouse)
    for name in "${!CH_COMMANDS[@]}"; do
        cmd=${CH_COMMANDS[$name]}
        ch_cmd=(clickhouse-client --database "nms" -q "$cmd")
        kubectl_cmd=(kubectl -n "${NMS_HELM_NAMESPACE}" exec "$ch_pod" -- "${ch_cmd[@]}")
        echo "Running command: " "${kubectl_cmd[@]}"
        "${kubectl_cmd[@]}" >"${output_dir}/$name" 2>"${output_dir}/${name}_stderr"
            if [ ! -s "${output_dir}/${name}_stderr" ]; then
                rm -f "${output_dir}/${name}_stderr"
            fi
    done
    echo "ClickHouse information collected"
}
# Dump data from dqlite database
dump_dqlite() {
    local output_dir="$1"
    local database="$2"
    create_path_if_not_exists "$output_dir"

    echo_section "Dump dqlite: $database"
    config_file="/etc/nms/nms.conf"

    case ${database} in
        "core")
        pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep core)"
        db_addr="0.0.0.0:7891"
        ;;
        "dpm")
        pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep dpm)"
        db_addr="0.0.0.0:7890"
        ;;
        "integrations")
        pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep integrations)"
        db_addr="0.0.0.0:7892"
        ;;
        "acm")
        pod_name="$(kubectl -n "${NMS_HELM_NAMESPACE}" get pods -o name | grep acm)"
        db_addr="0.0.0.0:9300"
        config_file=""
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
    kubectl -n "${NMS_HELM_NAMESPACE}" exec "${pod_name}" -- "${DQLITE_BACKUP_PATH}/${DQLITE_BACKUP_BIN}" -name "$database" -address "$db_addr" -config "$config_file" -output "${DQLITE_BACKUP_PATH}"
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
    # We require running in the 'support-package' sub-directory of the Chart directory
    if [ ! -f ${CHART_FILE} ]; then
      echo "Unable to find Chart.yaml: ${CHART_FILE}. Aborting."
      exit 1
    fi

    if ! command -v kubectl > /dev/null; then
      echo "Error: kubectl executable not found. Cannot proceed."
      exit 1
    fi

    if ! kubectl cluster-info > /dev/null; then
      echo "Error: could not reach Kubernetes API server. Is the kubeconfig present and valid?"
      exit 1
    fi
}

verify_namespace_accessible() {
    if ! kubectl get ns "$NMS_HELM_NAMESPACE" > /dev/null; then
      echo "Error: could not get provided Kubernetes namespace $NMS_HELM_NAMESPACE. Please confirm this is correct namespace and that appropriate permissions are granted."
      exit 1
    fi
}

main() {
    prompt_for_helm_install_info

    verify_namespace_accessible

    export PACKAGE_DIR SQLITE_BIN EXCLUDE_DB_DATA EXCLUDE_TS_DATA NMS_HELM_NAMESPACE

    if [ -d "pre.d" ]; then
        for script in pre.d/*; do
            [[ -e "$script" ]] || break  # handle the case of no files
            if [ ! -x "${script}" ]; then
                chmod +x "${script}"
            fi
            output=$(${script})
            rc=$?
            echo "${output}"
            if [ $rc -ne 0 ]; then
                echo "WARNING: ${script} failed"
            fi
        done
    fi

    # Chart files
    get_chart_files "$PACKAGE_DIR/chart-files"

    # Versions
    get_version_info "$PACKAGE_DIR/version-info"

    # Cluster
    get_cluster_info "$PACKAGE_DIR/cluster-info"

    # Namespace
    get_ns_info "$PACKAGE_DIR/namespace-info"
    get_ns_resources "$PACKAGE_DIR/namespace-info"

    # Application
    get_app_info "$PACKAGE_DIR/app-info"
    get_pod_logs "$PACKAGE_DIR/pod-logs"
    get_pod_system_info "$PACKAGE_DIR/pod-system-info"

    if ! $EXCLUDE_TS_DATA && is_ch_running; then
        dump_clickhouse "$PACKAGE_DIR/timeseries"
    else
        echo "excluding timeseries data from support package"
    fi

    if ! $EXCLUDE_DB_DATA; then
        dump_dqlite "$PACKAGE_DIR/dqlite/core" "core"
        dump_dqlite "$PACKAGE_DIR/dqlite/dpm" "dpm"
        dump_dqlite "$PACKAGE_DIR/dqlite/integrations" "integrations"
        if [[ "${NMS_MODULES}" == *"acm"* ]]; then
          dump_dqlite "$PACKAGE_DIR/dqlite/acm" "acm"
        fi

        ##  Back up App Delivery Manager
        # Uncomment the following lines to back up App Delivery Manager.
        # if [[ "${NMS_MODULES}" == *"adm"* ]]; then
        #  ./k8s-support-package-adm.sh
        #fi

    else
        echo "excluding database data from support package"
    fi

    if [ -d "post.d" ]; then
        for script in post.d/*; do
            [[ -e "$script" ]] || break  # handle the case of no files
            if [ ! -x "${script}" ]; then
                chmod +x "${script}"
            fi
            output=$(${script})
            rc=$?
            echo "${output}"
            if [ $rc -ne 0 ]; then
                echo "WARNING: ${script} failed"
            fi
        done
    fi
}

parse_args "$@"

# Verify pre-requisites and abort if any not met
verify_pre_reqs

echo "Using tmp directory: $PACKAGE_DIR"
create_path_if_not_exists "$PACKAGE_DIR"
# Call main() in a subshell and capture stdout/stderr in a file to be included
# in the support package.
(
    main
) 2>&1 | tee "$PACKAGE_DIR/k8s-support-package.log"

echo_section "Package output"
archive_file="$OUTPUT_DIR/$PACKAGE_NAME.tar.gz"
tar -C "/tmp" -czf "$archive_file" "$PACKAGE_NAME"
echo "Archive $archive_file ready"

rm -rf "$PACKAGE_DIR"

shopt -u nullglob
