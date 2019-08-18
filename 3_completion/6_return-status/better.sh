#!/usr/bin/env bash

function is_docker_installed_1 {
    if [ "$(which docker 2> /dev/null | wc -l)" -lt 1 ]; then
        return 0
    else
        return 1
    fi
}

if ! is_docker_installed_1 ; then
    apt-get install docker
fi
#=============
function is_docker_installed_2 {
    which docker &> /dev/null
}

is_docker_installed_2 || apt-get install docker

