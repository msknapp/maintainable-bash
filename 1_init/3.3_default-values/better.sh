#!/usr/bin/env bash

run() {
    local user=$(whoami)
    [ -z "$user" ] && user=$USER
    local password="${SYSTEM_PASSWORD:-${PASSWORD:-changeit}}"
    local token=''
    parse-quick-parameters 'user=-u,password=-p,token=-t' $@
    [ -z "$token" ] && [ -f "$HOME/.token" ] && token=$(cat $HOME/.token)
    [ -z "$token" ] && read -s -p "Please enter your token: " token
    # do something.
}