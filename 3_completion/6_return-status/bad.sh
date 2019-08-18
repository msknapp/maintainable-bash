#!/usr/bin/env bash

function is_docker_installed {
    if [ "$(which docker 2> /dev/null | wc -l)" -lt 1 ]; then
        echo "yes"
    else
        echo "no"
    fi
}

if [ "no" == "$(is_docker_installed)" ]; then
    apt-get install docker
fi

