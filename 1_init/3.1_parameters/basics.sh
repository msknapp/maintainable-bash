#!/usr/bin/env bash

function take_an_argument_the_ugly_way {
    echo "This demonstrates how your functions can take positional arguments."
    echo "Your first argument is: $1"
    echo "Second is: $2"
    echo "All arguments: $@"
}

function use_named_arguments {
    local name=${USER:-michael}
    local dob='1980-01-01'
    local eye_color='brown'
    local profession='software engineer'
    while [ "$1" ]; do
        case "$1" in
            -n|--name)shift;name=$1;;
            -d|--dob|--date-of-birth)shift;dob=$1;;
            -e|--eye|--eye-color)shift;eye_color=$1;;
            -p|--profession)shift;profession=$1;;
            -h|--help)
                cat << EOF
This demonstrates how you can use positional arguments, and return objects.


EOF
                return 0
                ;;
        esac
        shift
    done

    # Now to return our results as an object, we just use json:
    cat << EOF
{
    "name": "$name",
    "date-of-birth": "$dob",
    "profession": "$profession",
    "eye-color": "$eye_color"
}
EOF

}

function calling_a_function_with_named_parameters {
    use_named_arguments --name bob --dob 2000-06-01 --profession student -e blue
}