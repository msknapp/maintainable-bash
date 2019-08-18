#!/usr/bin/env bash

user=$1
# don't assume the argument was set.
[ -z "$user" ] && user=$(whoami)
# ~ or ~
[ -z "$user" ] && echo "Please specify your username." 1>&2 && return 1

# Check jq is installed
! which jq &> /dev/null && echo "please install jq." 1>&2 && return 2

# assumes an env variable is set.
pass=$THE_PASSWORD
[ -z "$pass" ] && read -s -p "Please enter your password: " pass
[ -z "$pass" ] && echo "Please set THE_PASSWORD" 1>&2 && return 3

# assumes an operation was successful.
if ! curl -d "$data" http://example.com/api/query?user=$user&pass=$pass \
    > /tmp/out.json \
    2> /tmp/error
then
    echo "Failed to query your API." 1>&2
    cat /tmp/error 1>&2
    return 4
fi

# Check that the file exists.
[ ! -f /tmp/out.json ] && echo "Your query did not produce output." 1>&2 && return 4

if ! jq -r '.output' < /tmp/out.json ; then
    echo "The output is not in the expected format" 1>&2
    return 5
fi