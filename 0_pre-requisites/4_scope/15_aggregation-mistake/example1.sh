#!/usr/bin/env bash

x=0
echo "initially x is: $x" # prints 0
( x=1;
echo "x in parntheses is: $x" # prints 1
)
echo "x is: $x" # prints 0