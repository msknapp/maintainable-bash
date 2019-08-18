#!/usr/bin/env bash

function t1 {
    a=1
    export b=2
    t2
    bash -c 'echo "a=$a, b=$b"'
}

function t2 {
    echo "a=$a, b=$b"
}

t1

function f {
    # Run in a sub-shell
    (
        local x=$1
        y=$1
        export z=$1
        print_vars "function f inside sub-shell"
    )
    print_vars "function f outside sub-shell"
}

function g {
    local x=$1
    y=$1
    export z=$1
    # Run in a sub-shell
    (
        print_vars "function g inside sub-shell"
    )
    print_vars "function g outside sub-shell"
}

function print_vars {
    echo "Variables from within ${1}:"
    echo "  x=$x, y=$y, z=$z"
}

function unset_vars {
    unset x
    unset y
    unset z
}

unset_vars
print_vars "script global scope after unsetting them"
f 1
print_vars "script global scope"
unset_vars
print_vars "script global scope after unsetting them"
g 2
print_vars "script global scope"