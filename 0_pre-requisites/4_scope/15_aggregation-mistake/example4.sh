#!/usr/bin/env bash

bad() {
    sum=0
    ls -l | grep .txt | awk '{print $5}' | while read line; do
        sum=$((sum+line))
    done
    echo "And the sum is: $sum"
}

good() {
    sum=0
    while read line; do
        sum=$((sum+line))
    done < <(ls -l | grep .txt | awk '{print $5}')
    echo "And the sum is: $sum"
}
