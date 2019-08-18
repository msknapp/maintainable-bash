#!/usr/bin/env bash

function say_hi {
    local name=''
    if [[ "$1" =~ -n|--name ]]; then
        shift
        name="$1"
    fi
    echo "Hi $name"
}
function print_favorites {
    local name=joe
    local food=pizza
    local color=blue
    local season=summer
    local pet=dog
    while [ "$1" ]; do
        case "$1" in
            -n|--name)shift;name="$1";;
            -f|--food)shift;food="$1";;
            -c|--color)shift;color="$1";;
            -s|--season)shift;season="$1";;
            -p|--pet)shift;pet="$1";;
        esac
        shift
    done
    echo "${name}'s Favorite food: ${food}"
    echo "${name}'s Favorite color: ${color}"
    echo "${name}'s Favorite season: ${season}"
    echo "${name}'s Favorite pet: ${pet}"
}
function main {
    say_hi --name joe
    print_favorites --name joe -f pizza -c blue --season summer -p dog
    print_favorites -f pizza -c blue -s summer -p dog
}
main $@