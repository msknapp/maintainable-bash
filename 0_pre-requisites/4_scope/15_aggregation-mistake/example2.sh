#!/usr/bin/env bash

sum=0
echo "Sum from start is: $sum"
printf "3\n5\n2\n" | while read line; do
    sum=$((sum+line))
    echo "Sum in while is: $sum"
done
echo "Sum at end is: $sum"