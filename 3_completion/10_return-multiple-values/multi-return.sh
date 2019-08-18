#!/usr/bin/env bash

function create_name {
    local name="$1"
    local first="${name:0:1}"
    local rem="${name:1:}"
    local piglatin="${rem}${first}ay"
    local piglatin_length="${#piglatin}"
    local length_squared=$((piglatin_length * piglatin_length))
    cat << EOF
{
    "original_name": "$name",
    "piglatin": "$piglatin",
    "length": "$piglatin_length",
    "length_squared": "$length_squared"
}
EOF
}

function create_name_2 {
    original_name="$1"
    local first="${name:0:1}"
    local rem="${name:1:}"
    piglatin="${rem}${first}ay"
    length="${#piglatin}"
    length_squared=$((piglatin_length * piglatin_length))
}

function main {
    names=( joseph peter sarah rachel )
    format="%-10s %-12s %-6s %s"
    printf "$format" Name Piglatin Length LengthSquared
    piglatin='unchanged'
    for name in $names ; do
        result=$(create_name "$name")
        name=$(jq -r '.original_name' <<< "$result")
        my_piglatin=$(jq -r '.piglatin' <<< "$result")
        length=$(jq -r '.length' <<< "$result")
        length_squared=$(jq -r '.length_squared' <<< "$result")
        printf "$format" "$name" "$my_piglatin" "$length" "$length_squared"
    done
    echo "the variable piglatin is $piglatin"

    names=( william maria gabrielle paul )
    for name in $names ; do
        create_name "$name"
        # This is much simpler, but is more risky because the variables leak from the sub-function,
        # overwriting variables in this function's scope.
        # also if the sub-function changes its variable names, then this function is broken.
        printf "$format" "$name" "$piglatin" "$length" "$length_squared"
    done
    echo "the variable piglatin is $piglatin"
}