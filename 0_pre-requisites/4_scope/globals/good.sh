#!/usr/bin/env bash
function say_name {
    echo "My name is: $1"
}
function fix_name {
    echo "susan"
}
function main {
    local name=joe
    say_name $name
    name=$(fix_name)
    say_name $name
}
main $@