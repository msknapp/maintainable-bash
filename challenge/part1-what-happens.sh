#!/usr/bin/env bash

# Here I show you code, and you must tell me what will happen if it's run.
# in each case, try to understand why.

set_var() {
    var="set"
}

problem1() {
    unset var; var="unset"
    set_var
    echo "1: var is $var"
    unset var; var="unset"
    { set_var; }
    echo "2: var is $var"
    unset var; var="unset"
    ( set_var )
    echo "3: var is $var"
    unset var; var="unset"
    : | set_var
    echo "4: var is $var"
    unset var; var="unset"
}

say_var() {
    echo "$1: var is $var"
}

problem2() {
    unset var; var="unset"
    local var=set
    say_var 1
    ( say_var 2 )
    { say_var 3; }
    : | say_var 4
    unset var; var="unset"
    var=set
    say_var 5
    ( say_var 6 )
    { say_var 7; }
    : | say_var 8
    unset var; var="unset"
    export var=set
    say_var 9
    ( say_var 10 )
    { say_var 11; }
    : | say_var 12
}

_p3_local() {
    local var="set"
}
_p3() {
    var="set"
}
_p3_export() {
    export var="set"
}

problem3() {
    var="unset"
    _p3_local
    echo "1: var is $var"
    var="unset"
    _p3
    echo "2: var is $var"
    var="unset"
    _p3_export
    echo "3: var is $var"
}

_problem4() {
    name=jeckyll
    echo "$1: I'm Mr. $name"
}

problem4() {
    name=hyde
    echo "1: I'm Mr. $name"
    _problem4 2
    echo "3: I'm Mr. $name"
    name=hyde
    echo "4: I'm Mr. $name"
    out=$(_problem4 5)
    echo "$out"
    echo "6: I'm Mr. $name"
}

_problem5() {
    name="$1"
    first=${name:0:1}
    rem=${name:1:${#name}}
    piglatin="${rem}${first}ay"
    length=${#piglatin}
}

problem5() {
    name=rachel
    length=${#name}
    _problem5 $name
    echo "The $length letter name $name becomes $piglatin in piglatin."
}

problem6() {
    false || true && echo "reached 1"
    true || false && echo "reached 2"
    false && true || echo "reached 3"
    true && false || echo "reached 4"
    false && true && echo "reached 5"
    true && false && echo "reached 6"
}

_problem7() {
    filter=''
    if [ "last_line" == "$1" ]; then
        filter="| tail -n 1"
    fi
    cat "/etc/passwd" $filter
}

problem7() {
    _problem7 last_line
}

problem8() {
    text="joseph 80
susan 90"
    for line in ${text}; do
        name=$(cut -d' ' -f1 <<< $line)
        score=$(cut -d' ' -f2 <<< $line)
        echo "${name}'s score was $score"
    done
}

problem9() {
    account_balances="joseph 70
susan 90
paula 75
billy 100
ralph 87"
    sum=0
    echo "$account_balances" | while read line; do
        score=$(cut -d' ' -f2 <<< "$line")
        sum="$((sum+score))"
    done
    echo "The sum is $sum"
}

_p10() {
    echo "Hello $1"
}

problem10() {
    _p10 "hacker\";rm -rf /tmp/;clear;\"true"
}

problem11() {
    text="
a
b
c
"
    echo $text | wc -l
    echo "$text" | wc -l
    text=$(cat << EOF
a
b
c
EOF
)
    echo $text | wc -l
    echo "$text" | wc -l
}

problem12() {
    opts='-l -a -h'
    ls "$opts" "$HOME"
}

_problem13() {
    people=$(cat << EOF
bill male 27
rose female 33
derek male 17
kara female 22
peter male 49
susan female 16
EOF
)
    local gender=''
    local min_age='0'
    local max_age='150'
    local op='either'
    while [ "$1" ]; do
        case "$1" in
            --male)gender=male;;
            --min)shift;min_age="$1";;
            --max)shift;max_age="$1";;
            --both)op='both';;
        esac
        shift
    done
    echo "$people" | while read line; do
        name=$(cut -d' ' -f1 <<< $line)
        gen=$(cut -d' ' -f2 <<< $line)
        age=$(cut -d' ' -f3 <<< $line)
        is_gender=false; [ -z "$gender" -o "$gen" == "$gender" ] && is_gender=true
        in_age=false; [ "$min_age" -le "$age" -a "$max_age" -gt "$age" ] && in_age=true
        oper='||'; [ "both" == "$op" ] && oper='&&'
        if $is_gender $oper $in_age; then
            echo "$line"
        fi
    done
}

problem13() {
    _problem13 --male --min 20 --max 35 --both
}

_problem14() {
    x="$1"
    y="$2"
    return $((x+y))
}

problem14() {
    _problem14 81 13
    echo "81 + 13 = $?"
    _problem14 123 217
    echo "123 + 217 = $?"
    _problem14 5 -8
    echo "5 - 8 = $?"
}

_problem15() {
    return "linus torvalds"
}

problem15() {
    name=$(_problem15)
    echo "The creator of linux is $name"
}

_problem16() {
    a="$1"; b="$2"
    echo "$((a+b))"
}

problem16() {
    y=$(_problem16 123 217)
    echo "123 + 217 = $y"
    y=$(_problem16 5 -8)
    echo "5 - 8 = $y"
}

problem18() {
    x=''; unset x
    [ -n $x ] && echo "x is set."
}

problem19() {
    three_squared='$((3*3))'
    echo "three squared is: $three_squared"
    echo "You are in debt, your balance is $(5)"
}

_problem20_1() {
    arg="$1"
    if [ $(echo "$arg" | wc -l) -gt 0 ]; then
        echo "your argument is set, the value is $arg"
    else
        echo "your argument is not set, because the value is \"$arg\""
    fi
}

_problem20_2() {
    arg="$1"
    if [ $(echo -n "$arg" | wc -l) -gt 0 ]; then
        echo "your argument is set, the value is $arg"
    else
        echo "your argument is not set, because the value is \"$arg\""
    fi
}

_problem20_3() {
    arg="$1"
    if [ $(wc -c <<< "$arg") -gt 0 ]; then
        echo "your argument is set, the value is $arg"
    else
        echo "your argument is not set, because the value is \"$arg\""
    fi
}

_problem20_4() {
    arg="$1"
    if [ ${#arg} -gt 0 ]; then
        echo "your argument is set, the value is $arg"
    else
        echo "your argument is not set, because the value is \"$arg\""
    fi
}

_problem20_5() {
    arg="$1"
    if [ ${arg} ]; then
        echo "your argument is set, the value is $arg"
    else
        echo "your argument is not set, because the value is \"$arg\""
    fi
}

problem20() {
    _problem20_1 x
    _problem20_1
    _problem20_2 x
    _problem20_2
    _problem20_3 x
    _problem20_3
    _problem20_4 x
    _problem20_4
    _problem20_5 x
    _problem20_5
}

_problem21() {
    a="$1"
    b="$2"
    debug=false; [[ "$3" =~ -d|--debug ]] && debug=true
    $debug && echo "Got arguments a=$a, b=$b"
    echo "$((a+b))"
}

problem21() {
    sum=$(_problem21 3 7 --debug)
    echo "3+7=$sum"
}
problem22() {
    DECADE=80
    echo "I like music from the $DECADEs"
}

problem23() {
    out="billy
sean
susan"
    echo $out | while read line; do
        echo "hello $line"
    done
    cat <<< $out | while read line; do
        echo "hello $line"
    done
}

problem24() {
    out="billy
sean
susan"
    while read line <<< "$out"; do
        echo "hello $line"
    done
}