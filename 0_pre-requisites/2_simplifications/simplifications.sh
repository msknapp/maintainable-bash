#!/usr/bin/env bash

function simplifications {
    local my_boolean=$1
    if [ "$my_boolean" == "true" ]; then
        echo "your boolean is true"
    fi
    echo "Resulting status code: $?"
    echo "The statement can be simplified:"
    if $my_boolean; then
        echo "your boolean is true."
        echo "In this case, bash interpreted 'true' as a command and executed that command."
        echo "Since the resulting status code of the 'true' program is always 0, it succeeded,"
        echo "so the if statement proceeded."
    fi
    echo "Resulting status code: $?"
    echo "The statement can be simplified even more:"
    $my_boolean && "Your boolean is true"
    echo "Resulting status code: $?"
    which bash &> /dev/null && echo "Bash is installed."
    echo "Resulting status code: $?"
    echo "Notice the difference, when you don't use an if statement, and the boolean is false, "
    echo "the final status code is non-zero/falsy/failure."
    echo
    echo "You can also use the or operator || to only do something upon failure:"
    $my_boolean || "Your boolean is false"
    which bash &> /dev/null || echo "Bash is not installed."
    which fake_program &> /dev/null || echo "fake_program is not installed."
    bad_curl &> /dev/null || echo "The host '' does not exist."

    echo "Another common pattern is like ternary in java, set a variable based on a boolean"
    local my_name='Michael' && $my_boolean && my_name="Michelle"
    echo "My name is $my_name because you set my_boolean to $my_boolean"
}