#!/usr/bin/env bash

# For demo, we use alphavantage, a free API for stock information.

function lesson1 {
    # return text without worrying about escaping quotes or back slashes: here documents.
    local lang=bash
    # A naive approach:
    echo "{"
    echo "  \"name\": \"Michael Knapp\","
    echo "  \"language\": \"$lang\","
    echo "}"

    cat << EOF
{
    "name": "Michael Knapp",
    "language": "$lang",
}
EOF
    # Ahh that was so much easier using a here document, and it's formatted nice.
}

# I encapsulate code in this function to isolate it.
function get_stock {
    # I use 'local' to make sure these variables don't leak to sub-functions.
    local host='www.alphavantage.co'
    local stock_symbol=COF

    # Here I am using an environment variable but only as a default value, it is easily over-written.
    local api_key=${API_KEY}
    local fnctn=TIME_SERIES_INTRADAY
    local dry_run=false
    local debug=false
    local format=text

    # We use named parameters for flexibility and readability.
    while [ "$1" ]; do
        # use a case statement instead of repeated if-elif-elif-...-fi
        case "$1" in
            -H|--host|--hostname|--host-name)shift;host=$1;;
            -s|--symbol|--stock|--ticker|--stock-symbol)shift;stock_symbol=$1;;
            -k|--key|--api-key)shift;api_key=$1;;
            --dry-run)dry_run=true;;
            --debug)debug=true;;
            --json)format=json;;
            -h|--help)
                # In many other scripts you see people write echo statements repeatedly.
                # I think this is tedious/verbose and quite cumbersome.
                # Use "here documents" to make it much easier to write multi-line text and not worry about
                # bash interpreting the text in the wrong way.
                cat << EOF
Prints some stock symbol information.

Assumptions:
* curl, and jq are installed

Parameters:
    -H|--host|--hostname|--host-name <arg> - Specify the alphavantage host name, defaults to www.alphavantage.co
    -s|--symbol|--stock|--ticker|--stock-symbol <arg> - Specify the stock symbol, defaults to COF.
    -k|--key|--api-key <arg> - provides your alphavantage API key.
    --dry-run - instead of running the command, print the command that would be run.
    --debug - print some extra debugging information.
    -h|--help - prints this help.

Examples:
    demo get-stock --stock-symbol MSFT

EOF
                return 0
                ;;
        esac
        shift
    done
    # For convenience, the user can store their key in a file.  If the API key is not set, then load it from that file.
    [ -z "${api_key}" ] && api_key=$(cat $HOME/.alpha-vantage-api-key)

    # If the API key is still not set, stop now.
    if [ -z "${api_key}" ]; then
        # Since this is a problem, and not part of the natural output of the program, write to standard error with 1>&2
        echo "You must set your alpha vantage API key." 1>&2
        return 2
    elif $debug; then
        echo "The API key is set to ${api_key}"
    fi
    if [ -z "${stock_symbol}" ]; then
        echo "You must specify a stock ticker symbol." 1>&2
        return 3
    elif $debug; then
        echo "The stock symbol is set to ${stock_symbol}"
    fi

    # Confirm the assumption that curl and jq are installed
    ! which curl &> /dev/null && echo "You must install curl" 1>&2 && return 4

    # They only need jq if they want the output as json.
    # Use && to chain together commands that only run if the previous one was successful.
    [ "$format" != "json" ] && ! which jq &> /dev/null && echo "You must install jq" 1>&2 && return 5
    $debug && echo "curl and jq are installed."

    # I split up variables so it's easier to read.
    local params="function=${fnctn}&symbol=${stock_symbol}&interval=5min&apikey=${api_key}"
    local url="https://${host}/query?${params}"

    if $dry_run; then
        $debug && echo "Running in dry-run mode."
        # To avoid needing some complicated escapes of quotation marks, I use a "here-document" to print the
        # dry-run output.  They may not want to use jq here, the user can remove parts of the command they don't want.
        cat << EOF
curl -k "${url}" 2> /dev/null | jq '."Time Series (5min)".[*]'
EOF
        # no need for return 0 here, since the command above will always be successful its status will be zero
        # and hence this function will return 0.  Bash naturally returns the status of the last command it ran in a function.
    else
        $debug && echo "Running in regular mode."
        # The 2> /dev/null ensures that the standard error output from curl does not display for the end user.
        # Check that this curl command is successful using an if statement.
        if ! output=$(curl -k "${url}" 2> /dev/null); then
            # inform the user of the failure, on standard error using 1>&2
            echo "Failed to curl alphavantage." 1>&2
            # Returning a non-zero value means the program failed.  I like to use 1 for the
            # most typical failure mode.
            return 1
        fi
        # if they just want json, print it now.
        [ "$format" == "json" ] && cat <<< $output && return 0
        # at this point, they must want a text output.
        # jq can be used to select just some json fields to output.
        jq -r '."Time Series (5min)"  ' <<< $output
    fi
}

function demo_main {
    local operation=$1
    shift
    case "$operation" in
        get-stock|--get-stock)get_stock $*;;
        help|-h|--help)
            cat << EOF
Demonstrates how to write maintainable bash scripts.

Assumptions:
* curl, and jq are installed

Sub-commands:
    get-stock|--get-stock - prints stock information.
    help|-h|--help - prints this help

For help on sub-commands enter:
    demo <sub-command> [-h|--help]

EOF
            ;;
    esac
}

demo_main $@