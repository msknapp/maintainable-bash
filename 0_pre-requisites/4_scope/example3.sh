#!/usr/bin/env bash

function __scope_check {
    local sub_function_local_variable="set"
    sub_function_regular_variable="set"
    export sub_function_exported_variable="set"
    echo "  From within the scope check function:"
    echo "    local_variable is ${local_variable:-not set}"
    echo "    regular_variable is ${regular_variable:-not set}"
    echo "    exported_variable is ${exported_variable:-not set}"

    echo "  Now we test using a sub-process, from within the scope check sub-process:"
    (
        echo "    local_variable is ${local_variable:-not set}"
        echo "    regular_variable is ${regular_variable:-not set}"
        echo "    exported_variable is ${exported_variable:-not set}"
        echo "    sub_function_local_variable is ${sub_function_local_variable:-not set}"
        echo "    sub_function_regular_variable is ${sub_function_regular_variable:-not set}"
        echo "    sub_function_exported_variable is ${sub_function_exported_variable:-not set}"
    )
}

function scope_example {
    unset local_variable
    unset regular_variable
    unset exported_variable
    local local_variable="set"
    regular_variable="set"
    export exported_variable="set"
    __scope_check
    echo "  From within the scope example:"
    echo "    sub_function_local_variable is ${sub_function_local_variable:-not set}"
    echo "    sub_function_regular_variable is ${regular_variable:-not set}"
    echo "    sub_function_exported_variable is ${sub_function_exported_variable:-not set}"

    unset local_variable_2
    unset local_variable_3
    bash -c 'local_variable_2=set'
    # source bash -c 'local_variable_3=set'
    echo "    local_variable_2 is ${local_variable_2:-not set}"
    echo "    local_variable_3 is ${local_variable_3:-not set}"
}

scope_example