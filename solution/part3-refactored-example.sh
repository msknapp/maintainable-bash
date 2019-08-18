#!/usr/bin/env bash

function check_for_non_running_pods {
    local context=''; local dry_run=false; local debug=false
    while [ "$1" ]; do
        case "$1" in
            -c|--context)shift;context=$1;;
            --dry-run)dry_run=true;;
            --debug)debug=true;;
            -h|--help)
                cat <<  EOF
Finds all pods that are not running or completed.

Parameters:
    -c|--context <arg> - set the k8s context
    --dry-run - print the command you would run without running it.
    --debug - print extra troubleshooting information.
    -h|--help - print this help information.

EOF
                return 0
                ;;
        esac
        shift
    done
    context_arg=''; [ -n "$context" ] && context_arg='--context '$context
    if $dry_run; then
        cat << EOF
Would run this command:
kubectl ${context_arg} get po --all-namespaces --no-headers | grep -vE "(Running|Completed)"
EOF
    else
        if ! out=$(kubectl ${context_arg} get po --all-namespaces --no-headers | grep -vE "(Running|Completed)"); then
            echo "Failed to get pods" 1>&2
            return 2
        else
            [ -n "$out" ] && { cat <<< $out; return 1 }
            return 0
        fi
    fi
}

function check_for_unready_nodes {
    local context=''; local dry_run=false; local debug=false
    while [ "$1" ]; do
        case "$1" in
            -c|--context)shift;context=$1;;
            --dry-run)dry_run=true;;
            --debug)debug=true;;
            -h|--help)
                cat <<  EOF
Finds all nodes that are not ready.

Parameters:
    -c|--context <arg> - set the k8s context
    --dry-run - print the command you would run without running it.
    --debug - print extra troubleshooting information.
    -h|--help - print this help information.

EOF
                return 0
                ;;
        esac
        shift
    done
    context_arg='' && [ -n "$context" ] && context_arg='--context '$context
    if $dry_run; then
        cat << EOF
Would run:
kubectl ${context_arg} get nodes --no-headers | grep -v Ready
EOF
    else
        if out=$(kubectl ${context_arg} get nodes --no-headers | grep -v Ready); then
            $debug && echo "successfully got nodes." 1>&2

            if [ -n "$out" ]; then
                cat <<< $out
                return 1
            fi
        else

        fi
    fi
    return 0
}

function check_for_errors {
    local pod=''; local dry_run=false; local debug=false; local context=''
    while [ "$1" ]; do
        case "$1" in
            -c|--context)shift;context="$1";;
            -p|--pod)shift;pod="$1";;
            --dry-run)dry_run=true;;
            --debug)debug=true;;
            -h|--help)
                cat <<  EOF
Checks a specific pod for any errors.

Parameters:
    -p|--pod <arg> - Sets the pod you want logs for.
    -c|--context <arg> - set the k8s context
    --dry-run - print the command you would run without running it.
    --debug - print extra troubleshooting information.
    -h|--help - print this help information.

EOF
                return 0
                ;;
        esac
        shift
    done
    context_arg=''; [ -n "$context" ] && context_arg='--context '$context
    if $dry_run; then
        cat << EOF
Would run:
kubectl ${context_arg} logs "${pod}" | grep Error
EOF
    else
        if kubectl ${context_arg} logs "${pod}" | grep Error; then
            $debug && echo "Successfully got the logs" 1>&2
        else
            echo "Failed to get the logs" 1>&2
            return 1
        fi
    fi
}

function check_for_app {
    local app=''; local dry_run=false; local debug=false
    local app_type=deploy
    local namespace=''
    local context=''
    while [ "$1" ]; do
        case "$1" in
            -c|--context)shift;context=$1;;
            -t|--type)shift;app_type=$1;;
            --sts)app_type=sts;;
            -a|--app)shift;app=$1;;
            -n|--namespace)shift;namespace=$1;;
            --all-namespaces)namespace=all;;
            --dry-run)dry_run=true;;
            --debug)debug=true;;
            -h|--help)
                cat <<  EOF
Checks if an app is present on the cluster.  The return status is successful if the app is present.

Parameters:
    -t|--type <arg> - sets the app name.
    --sts - sets the app type to stateful set
    -a|--app <arg> - sets the app.
    -n|--namespace <arg> - sets the namespace
    --all-namespaces - Search all namespaces.
    -c|--context <arg> - set the k8s context
    --dry-run - print the command you would run without running it.
    --debug - print extra troubleshooting information.
    -h|--help - print this help information.

EOF
                return 0
                ;;
        esac
        shift
    done
    context_arg='' && [ -n "$context" ] && context_arg='--context '$context
    namespace_arg=''
    if [ "all" == "$namespace" ]; then
        namespace_arg='--all-namespaces'
    elif [ "$namespace" ]; then
        namespace_arg='--namespace '$namespace
    fi
    if $dry_run; then
        cat << EOF
Would run:
kubectl ${context_arg} ${namespace_arg} get ${app_type} ${app} --no-headers
EOF
    else
        if out=$(kubectl ${context_arg} ${namespace_arg} get ${app_type} ${app} --no-headers); then
            $debug && echo "Successfully got apps." 1>&2
            ready=$(awk '{print $3}' <<< $out)
            low=$(cut -d/ -f1 <<< $ready)
            high=$(cut -d/ -f2 <<< $ready)
            $debug && echo "ready: $ready, low: $low, high: $high" 1>&2
            [ $low -eq $high ]
        else
            echo "Failed to get apps" 1>&2
            return 1
        fi
    fi
}

function validation {
    [[ "$1" =~ help|-h|--help ]] && {
        cat << EOF
Runs the basic cluster validation
EOF
        return 0
    }
    check_for_unready_nodes $@
    check_for_non_running_pods $@
    for app in hadoop mongo apache; do
        check_for_app --app ${app} $@
    done
}

function k8s_cluster_validation_main {
    # Assume you already have a token.
    local operation="$1"; shift
    ! which kubectl &> /dev/null && echo "Warning: kubectl is not installed." 1>&2
    case "$operation" in
        validate) validation $@;;
        unready-nodes) check_for_unready_nodes $@;;
        non-running-pods) check_for_non_running_pods $@;;
        check-for-app) check_for_app $@;;
        -h|--help)
            cat << EOF
Validates that a K8s cluster is operational.

Sub-commands:
    validate - runs a full validation.
    unready-nodes - finds nodes that are not ready.
    non-running-pods - finds pods that are not running.
    check-for-app - checks if a particular app is running
    -h|--help - prints this help.

To get help on a sub-command, run:
    $ validation <sub-command> [-h|--help]

Assumptions:
    * kubectl is installed.

Examples:
    validation validate --context qa
    validation non-running-pods --context prod --dry-run --debug

EOF
            return 0
            ;;
    esac
}

k8s_cluster_validation_main $@