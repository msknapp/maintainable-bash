#!/usr/bin/env bash

function is_this_greater_than_ten {
    # this demonstrates how a function can return a status code.
    local number=$1
    if [ "$number" -gt 10 ]; then
        # return in a function is a way of delivering the status code.
        # in bash, 0 means good/successful/true, and anything else means bad/failure/false.
        return 0
    fi
    return 1
}

function bad_curl {
    curl -k "http://" &> /dev/null
}

function use_function_status {
    # every function or command in bash returns a status code that is an integer,
    # bash treats 0 as success/true

    echo "Here is the ugly way of using functions status:"
    is_this_greater_than_ten 20
    if [ "$?" -eq 0 ]; then
        echo "20 is greater than 10"
    else
        echo "20 is not greater than 10"
    fi

    echo "Here is the better way of using functions status:"
    if is_this_greater_than_ten 20; then
        echo "20 is greater than 10"
    else
        echo "20 is not greater than 10"
    fi

    # in bash, the command "true" is just a program that always returns 0 for its status code,
    # and "false" is just a program that never returns 0 for its status code.
    if true; then
        echo "The true command was found."
    fi
    # The ! symbol reverses the status code.
    if ! false; then
        echo "The false command was found."
    fi

    echo "Also worth noting, the return status of a function will be the return status of the last command it ran."
    if ! bad_curl ; then
        echo "In this case, we invoked the 'bad_curl' function, which returned a non-zero status code, which came directly from the curl command inside it."
    fi

}