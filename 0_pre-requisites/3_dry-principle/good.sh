#!/usr/bin/env bash

function say_hello_and_the_day {
    subject=$1
    local today=$2
    echo "hello world it's $today"
}

function main {
    local today=Friday
    for s in world mercury venus mars; do
        say_hello_and_the_day $s $today
    done
}

main $@