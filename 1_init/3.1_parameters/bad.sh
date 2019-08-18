#!/usr/bin/env bash

function say_hi {
    echo "Hi $1"
}
function print_favorites {
    echo "$1's Favorite food: $2"
    echo "$1's Favorite color: $3"
    echo "$1's Favorite season: $4"
    echo "$1's Favorite pet: $5"
}
function main {
    say_hi joe
    print_favorites joe pizza blue summer dog
    print_favorites pizza blue summer dog
}
main $@