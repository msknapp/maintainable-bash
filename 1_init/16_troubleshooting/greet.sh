#!/usr/bin/env bash
function greet {
    local debug=false; local dry_run=false; local name=joe
    local verbosity=0
    while [ "$1" ]; do
        case "$1" in
            --debug)debug=true;;
            --dry_run)dry_run=true;;
            -n|--name)shift;name="$1";;
            -v|--verbose)verbosity=$((verbosity+1));;
        esac
        shift
    done
    $debug && echo "The user provided the name: $name" 1>&2
    $debug && [ "$verbosity" -gt 1 ] && echo "$(date)" 1>&2
    $debug && [ "$verbosity" -gt 2 ] && echo "OMG this is soooo verbose!" 1>&2
    if $dry_run; then
        echo "Would run:" 1>&2
        cat 1>&2 << EOF
echo "Hello $name"
EOF
    else
        echo "Hello $name"
    fi
}
set -x
greet $@
set +x