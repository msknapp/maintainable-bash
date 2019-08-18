#!/usr/bin/env bash

export sum=1
add() {
    for x in $@; do
        sum=$((sum+x))
    done
}
: | add 3 5 2
echo "The sum using add in a pipe is $sum"

echo "Now adding without a pipe..."
export sum=1
add 3 5 2
echo "The sum without using a pipe (sub-shell) is $sum"
