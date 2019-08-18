#!/usr/bin/env bash
function say_name {
    echo "My name is: $NAME"
}
function fix_name {
    export NAME=susan
}
function main {
    export NAME=joe
    say_name
    fix_name
    say_name
}
main $@