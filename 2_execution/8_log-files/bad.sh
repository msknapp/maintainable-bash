#!/usr/bin/env bash

function get_name {
    local log_file=/var/log/action.log
    parse-quick-parameters 'log_file=-l|--log-file' $@
    echo "Going to call whoami" >> $log_file
    name=$(whoami)
    echo "Found the name is: $name" >> $log_file
    echo -n "$name"
}

name=$(get_name --log-file /home/bob/get-name.log)
echo "Good morning $name"