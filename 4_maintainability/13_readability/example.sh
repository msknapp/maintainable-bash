#!/usr/bin/env bash

keep_rows_containing(){ grep "$1";}
keep_column_number(){ awk '{print $'$1'}'; }
print_text(){ cat <<< "$1";}

people_status=$(cat << EOF
mike true
henry false
susan true
rachel false
EOF
)

function list_people_going {
    print_text "$people_status" | keep_rows_containing "true" | keep_column_number 1
}
list_people_going