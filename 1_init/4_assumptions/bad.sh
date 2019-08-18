#!/usr/bin/env bash

# assumes an argument was set.
user=$1
# assumes an env variable is set.
password=$THE_PASSWORD

# assumes an operation was successful.
url="http://example.com/api/query"
query_parms="user=$user&password=$password"
curl -d "$data" "${url}?${query_parms}" > \
    /tmp/out.json

# assumes a file exists.
# assumes jq is installed.
jq -r '.output' < /tmp/out.json