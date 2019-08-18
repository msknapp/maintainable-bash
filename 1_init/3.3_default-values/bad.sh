#!/usr/bin/env bash

run() {
    local user=''
    local password=''
    local token=''
    parse-quick-parameters 'user=-u,password=-p,token=-t' $@
    # do something.
}