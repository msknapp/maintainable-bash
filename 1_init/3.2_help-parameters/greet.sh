#!/usr/bin/env bash

function main {
    local greeting='hello'; local names=(); local caps=false
    while [ "$1" ]; do
        case "$1" in
            -n|--name|--names)
                while ! [[ "$2" =~ -.* ]]; do
                    shift; names+="$1"
                done
                ;;
            -g|--greeting) shift; greeting="$1";;
            -c|--caps) caps=true;;
            -h|--help|help) cat << EOF
greet: Prints a greeting.

Parameters:
    -n|--name|--names <arg> ... - Sets the names
    -g|--greeting <arg> - Sets the greeting, the default is 'hello'
    -c|--caps - sets the output to write in all caps.
    -h|--help|help - prints this help information.

Assumptions:
    - awk is installed.

Examples:
    greet -n joe shmoe --greeting "Good morning" --caps
    # output:
    # GOOD MORNING JOE SHMOE

EOF
                return 0 ;;
        esac
        shift
    done
    // not shown: check that awk is installed.
    fin='cat'; $caps && fin="awk '{print \$1}'"
    {
        echo -n "$greeting"
        for n in $names ; do
            echo -n " $n"
        done
    } | $fin
    echo
}
main $@