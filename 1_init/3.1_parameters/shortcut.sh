#!/usr/bin/env bash

function parse_quick_parameters {
    local t="${BASH_VERSION:0:1}"
    [ "$t" -lt 4 ] && echo "Your bash version needs to be updated to 4+" && return 1
    local def="$1"
    shift
    declare -A parm_map
    for part in $(tr ',' ' ' <<< "$def"); do
        local variable=$(cut -d= -f1 <<< $part)
        if [[ "$variable" =~ bool:.* ]]; then
            var_name="${variable#*:}"
            eval "$var_name=false"
        fi
        local commands=$(cut -d= -f2 <<< $part)
        for command in $(tr '|' ' ' <<< "$commands"); do
            parm_map[$command]=$variable
        done
    done
    while [ "$1" ]; do
        if [[ "$1" =~ -h|--help ]]; then
            echo "Parameters:"
            for part in $(tr ',' ' ' <<< "$def"); do
                local variable=$(cut -d= -f1 <<< $part)
                local commands=$(cut -d= -f2 <<< $part)
                echo "  ${commands} <arg> - Sets the variable '$variable'"
            done
            echo "  -h|--help - prints this help"
            echo
            return 1
        fi
        echo "Encountered: $1"
        if [[ "$1" =~ -.* ]]; then
            local var_name="${parm_map[$1]}"
            if [[ "$var_name" =~ bool:.* ]]; then
                var_name="${var_name#*:}"
                eval "$var_name=true"
            else
                shift
                eval "$var_name='$1'"
            fi
        fi
        shift
    done
}

function do_something_quick {
    parse_quick_parameters "my_file=-f|--file,bool:run=-r|--run,name=-n|--name" $@ || return 0
    echo "my file is: $my_file"
    echo "my name is: $name"
    echo "run is: $run"
}

do_something_quick $@