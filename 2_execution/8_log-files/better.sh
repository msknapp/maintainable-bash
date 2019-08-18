#!/usr/bin/env bash

function get_name {
    echo "Going to call whoami" 1>&2
    name=$(whoami)
    echo "Found the name is: $name" 1>&2
    echo -n "$name"
}

# https://catonmat.net/bash-one-liners-explained-part-three
# https://stackoverflow.com/questions/962255/how-to-store-standard-error-in-a-variable

mypipe=/tmp/myfifo
mkfifo ${mypipe}

name=$(get_name)
echo "Good morning $name"
# ~ or ~
name=$(get_name 2> /dev/null)
# ~ or ~
name=$(get_name 2>&1 1>${mypipe} )


# ~ or ~
action >> /home/bob/bobs-action.log 2>> /home/bob/bobs-errors.log
# ~ or ~
action 2>&1 | grep failure
# ~ or ~
logs=$(action)

