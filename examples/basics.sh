#!/usr/bin/env bash

function produce_multi_line_text_wrong_way {
    # this demonstrates how to print multiple lines of text the wrong/verbose way.
    echo "1 a"
    echo "2 b"
    echo "3 c"
}

function produce_multi_line_text {
    # this demonstrates how to print multiple lines of text without repeatedly using echo
    # the '<<' means a "here document" follows.
    cat << EOF
1 a
2 b
3 c
EOF

    echo "To print text with variables:"
    local y=3
    cat << EOF
a=1
x=$y
EOF
    echo "To print text without any interpretation of variables:"
    cat << "EOF"
a=1
x=$y
EOF

}

function dummy_function {
    echo "alpha beta"
    echo "charlie delta"
    echo "echo foxtrot"
}

function call_another_function {
    echo "this demonstrates how your code can call on other functions:"
    dummy_function

    echo "This demonstrates how you can capture the output of other commands:"
    # This is similar to having a return statement in other languages.
    output=$(dummy_function)
    echo "Notice how we called another function but just captured its output instead of printing it."

    echo "This demonstrates how you can print a variable that has multiple lines of text in it:"
    echo "The wrong way:"
    echo $output
    echo "Notice it's all on a single line.  Here is the right way:"
    cat <<< $output
    # the <<< means that the command should use the text to the right as its standard input.
}

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

function select_second_column {
    # When you have column data in text, the easiest way to select each
    # column is using awk.
    my_text=$(cat << EOF
1 2
2  4
3 8
4   16
EOF
)
    echo "to print just the second column:"
    cat <<< $my_text | awk '{print $2}'

    echo "an alternative shorter method:"
    awk '{print $2}' <<< $my_text

    # A bad method to use is cut because it does not work well when the spacing in columns is uneven.
    echo "a bad method of selecting columns is using 'cut':"
    cut -d' ' -f 2 <<< $my_text
}

function filter_rows {
    # filtering is easy with grep:
    rows=$(cat << EOF
she sells
sea shells
by the
sea shore.
EOF
)
    # a less crafty method:
    # cat <<< $rows | grep "sea"
    echo "Grepping on sea"
    grep "sea" <<< $rows

    echo "Printing just the first two lines:"
    # See just the first two lines
    head -n 2 <<< $rows

    echo "Printing just the last line:"
    # See just the last line:
    tail -n 1 <<< $rows

    echo "Printing all except the first two lines:"
    # See all except the first two lines (assuming you don't know the number of lines)
    tail -n -2 <<< $rows

    echo "Printing all except the last two lines:"
    # See all except the last two lines (assuming you don't know the number of lines)
    head -n +2 <<< $rows
}

function replace_text {
    # replacing text is easy with sed
    rows=$(cat << EOF
she sells
see shells
by the
see shore.
EOF
)
    sed 's/see/sea/g' <<< $rows
}

function do_simple_integer_math {
    echo $(($1 * 2))
}

function a_command_that_uses_standard_input {
    while read line; do
        number=$(echo $line | awk '{print $1}')
        # an alternative, better way of extracting a value:
        name=$(awk '{print $2}' <<< $line)
        len=${#name}
        first_letter=${name:0:1}
        remaining_name=${name:1:$len}
        piglatin="${remaining_name}${first_letter}ay"
        printf "%-7s %-8s %-8s %-7s %-12s\n" $number "$(do_simple_integer_math $number)" "$(($number * $number))" $name $piglatin
    done
}

function a_command_that_writes_to_standard_input {
    printf "%-7s %-8s %-8s %-7s %-12s\n" number times_2 squared  name piglatin_name
    # This demonstrates calling on another function and providing an input stream to it.
    a_command_that_uses_standard_input << EOF
1 robert
2 sarah
3 billy
EOF
}

function building_up_strings {
    # building up strings is easy.
    # for starters, you can use the same "here document" trick I showed before:
    local tempstring=$(cat << EOF
$(use_named_arguments --name bob --dob 2000-06-01 --profession student -e blue)
$(use_named_arguments --name janet --dob 1997-09-01 --profession teacher -e green)
EOF
)
    # but you can also append to strings by referring to their current value.
    tempstring="$tempstring
$(use_named_arguments --name sarah --dob 1992-02-01 --profession manager -e blue)"

    cat <<< $tempstring
}

function using_json_from_functions {
    local student="$(use_named_arguments --name bob --dob 2000-06-01 --profession student -e blue)"
    # Working with this "object" is easy with jq
    # let's say we want just his name:
    local name=$(echo "$student" | jq -r '.name')
    # a shorter method is to skip the echo statement
    local dob=$(jq -r '.date-of-birth' <<< $student)
    echo "We found a student named $name, born on $dob"
}

function aggregating {
    # A common problem is to count the number of times something happens, but this is very easily done wrong.
    local my_count=0
    local my_programs="
bash
which
netcat
cat
spark
hadoop
jq
netstat
go
open
python
perl
ruby"
    # let's say for example that we want to count all of the programs above if they are installed.
    # a naive approach
    cat <<< "$my_programs" | while read program; do
        # we want to check if the program is installed and on the user's path.  We can do this with the bash builtin 'which' command,
        # but we are not interested in the actual output of the which command, we are only interested in
        # if the command succeeds or not.  To ignore all output, we append '&> /dev/null' to the command.
        if which $program &> /dev/null; then
            my_count=$((my_count + 1))
        fi
    done
    echo "We found $my_count programs installed on your path"
    cat << "EOF"
To our astonishment, the count is always 0.  how can that be?  We know these programs are installed.
The problem is the counting is done in a "subshell", which happens because of the pipe '|' before our
while statement.  When we increment the my_count variable, that information is lost as soon as the sub-shell exits.

This may seem like a better approach:
while read program <<< $my_programs; do...
but that actually turns into an infinite loop as it keeps reading the same first line repeatedly.
the same thing happens with this:
while read program; do
...
done <<< $my_programs
EOF

    # So how do you do it?
    while read program; do
        # we want to check if the program is installed and on the user's path.  We can do this with the bash builtin 'which' command,
        # but we are not interested in the actual output of the which command, we are only interested in
        # if the command succeeds or not.  To ignore all output, we append '&> /dev/null' to the command.
        if which $program &> /dev/null; then
            my_count=$((my_count + 1))
        fi
    done < <(cat <<< $my_programs)
    echo "We found $my_count programs installed on your path"
}

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

function bad_logged_repeater {
    # Here we want to
    local message='hello world'
    local times=1
    while [ "$1" ]; do
        case "$1" in
            -m|--message)shift;message=$1;;
            -t|--times)shift;times=$1;;
        esac
        shift
    done
    for x in $(seq 1 $times); do
        echo "Repeating a message on iteration $x"
        echo $message
    done
}

function good_logged_repeater {
    # Here we want to
    local message='hello world'
    local times=1
    while [ "$1" ]; do
        case "$1" in
            -m|--message)shift;message=$1;;
            -t|--times)shift;times=$1;;
        esac
        shift
    done
    for x in $(seq 1 $times); do
        # This is our 'log' message.
        # By appending 1>&2 we are telling bash to forward the commands standard output to standard error output.
        echo "Repeating a message on iteration $x" 1>&2
        echo $message
    done
}

function repeater_user {
    bad_out=$(bad_logged_repeater --message bad --times 3)
    echo "Notice that when we invoke the 'good_logged_repeater', only the lines written to standard error get printed "
    echo "to the console here."
    good_out=$(good_logged_repeater --message good --times 3)
    echo "The lines above came from the standard error output of the 'good_logged_repeater' function."
    echo "Here is the 'bad' output:"
    cat <<< $bad_out
    echo "Here is the 'good' output:"
    cat <<< $good_out
    echo "Do you notice the difference?  When you want a function to return a value, and also log messages, "
    echo "Then have the log messages printed to standard error using 1>&2"
}

function __scope_check {
    local sub_function_local_variable="set"
    sub_function_regular_variable="set"
    export sub_function_exported_variable="set"
    echo "  From within the scope check function:"
    echo "    local_variable is ${local_variable:-not set}"
    echo "    regular_variable is ${regular_variable:-not set}"
    echo "    exported_variable is ${exported_variable:-not set}"

    echo "  Now we test using a sub-process, from within the scope check sub-process:"
    bash -c '    echo "    local_variable is ${local_variable:-not set}"'
    bash -c '    echo "    regular_variable is ${regular_variable:-not set}"'
    bash -c '    echo "    exported_variable is ${exported_variable:-not set}"'
    bash -c '    echo "    sub_function_local_variable is ${sub_function_local_variable:-not set}"'
    bash -c '    echo "    sub_function_regular_variable is ${sub_function_regular_variable:-not set}"'
    bash -c '    echo "    sub_function_exported_variable is ${sub_function_exported_variable:-not set}"'
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
    source bash -c 'local_variable_3=set'
    echo "    local_variable_2 is ${local_variable_2:-not set}"
    echo "    local_variable_3 is ${local_variable_3:-not set}"
}

function __print_func {
    echo
    echo "#--------------------"
    echo -n "function "
    type $1 | tail -n +2
    echo "#--------------------"
}

function __run_func {
    tmux run -t basicdemo:main.1 echo
    cmd='echo \"# Invoking: '$*'\"'
    tmux run -t basicdemo:main.1 "$cmd"
    tmux run -t basicdemo:main.1 'echo "#---- Output: -------"'
    out=$($*)
    tmux run -t basicdemo:main.1 "cat <<< \"$out\""
    tmux run -t basicdemo:main.1 'echo "#--------------------"'
}

function _lesson1 {
    echo "Lesson 1: printing multiple lines of text:"
    __print_func produce_multi_line_text_wrong_way
    __run_func produce_multi_line_text_wrong_way
    read -p "hit enter to continue"
    __print_func produce_multi_line_text
    __run_func produce_multi_line_text
    echo
    read -p "End of lesson, hit enter to continue on to the next lesson"
}

function _lesson2 {
    echo "Lesson 2: Invoking one function from another function."
    __print_func dummy_function
    __print_func call_another_function
    __run_func call_another_function
    echo
    read -p "End of lesson, hit enter to continue on to the next lesson"
}

function _lesson3 {
    echo "Lesson 3: Using arguments in functions"
    __print_func take_an_argument_the_ugly_way
    __run_func take_an_argument_the_ugly_way argument1 argument2 argument3 argument4 "multi arg"
    read -p "hit enter to continue"
    __print_func use_named_arguments
    __run_func use_named_arguments --name peter --dob 1991-10-15 -e blue --profession soldier
    read -p "hit enter to continue"
    __print_func calling_a_function_with_named_parameters
    __run_func calling_a_function_with_named_parameters
    echo
    read -p "End of lesson, hit enter to continue on to the next lesson"
}

function _lesson4 {
    echo "Lesson 4: Using A Function's return status"
    __print_func is_this_greater_than_ten
    __run_func is_this_greater_than_ten 1
    __run_func is_this_greater_than_ten 100
    echo "... Notice there is no output.  'return' is reporting back a status code instead, you can't see it."
    read -p "hit enter to continue"
    __print_func bad_curl
    __print_func use_function_status
    __run_func use_function_status
    echo
    read -p "End of lesson, hit enter to continue on to the next lesson"
}

function _lesson5 {
    echo "Lesson 5: Selecting Data"
    __print_func select_second_column
    __run_func select_second_column
    read -p "hit enter to continue"
    __print_func filter_rows
    __run_func filter_rows
    read -p "hit enter to continue"
    __print_func replace_text
    __run_func replace_text
    echo
    read -p "End of lesson, hit enter to continue on to the next lesson"
}

function _lesson6 {
    echo "Lesson 6: Streaming Between Functions"
    __print_func do_simple_integer_math
    __run_func do_simple_integer_math 3
    read -p "hit enter to continue"
    __print_func a_command_that_uses_standard_input
    read -p "hit enter to continue"
    __print_func a_command_that_writes_to_standard_input
    __run_func a_command_that_writes_to_standard_input
    echo
    read -p "End of lesson, hit enter to continue on to the next lesson"
}

function _lesson7 {
    echo "Lesson 7: Building up strings"
    __print_func building_up_strings
    __run_func building_up_strings
    echo
    read -p "End of lesson, hit enter to continue on to the next lesson"
}

function _lesson8 {
    echo "Lesson 8: Simplifying if statements"
    __print_func bad_curl
    __print_func simplifications
    __run_func simplifications true
    read -p "hit enter to continue"
    __run_func simplifications false
    echo
    read -p "End of lesson, hit enter to continue on to the next lesson"
}

function _lesson9 {
    echo "Lesson 9: Logging in functions with return values."
    __print_func bad_logged_repeater
    read -p "hit enter to continue"
    __print_func good_logged_repeater
    read -p "hit enter to continue"
    __print_func repeater_user
    __run_func repeater_user
    echo
    read -p "End of lesson, hit enter to continue on to the next lesson"
}

function _lesson10 {
    echo "Lesson 10: Aggregating data"
    __print_func aggregating
    __run_func aggregating
    echo
    read -p "End of lesson, hit enter to exit the tutorial."
}

function _lesson11 {
    echo "Lesson 11: Understanding Variable Scope"
    __print_func __scope_check
    __print_func scope_example
    echo "What do you think will happen..."
    read -p "hit enter to continue"
    __run_func scope_example
    echo
    read -p "End of lesson, hit enter to exit the tutorial."
}

function demo_in_tmux {
    local sleep_interval=5
    local starting_lesson=1
    local ending_lesson=100
    while [ "$1" ]; do
        case "$1" in
            -i|--interval|--sleep-interval)shift;sleep_interval=$1;;
            -s)shift;starting_lesson=$1;;
            -e)shift;ending_lesson=$1;;
            -h|--help)
                cat << EOF
Demonstrates the bash methods.
EOF
                return 0
                ;;
        esac
        shift
    done
    clear
    echo "Welcome to the bash scripting basics tutorial/demo."
    for lesson in $(seq 1 11); do
        if [ "$starting_lesson" -lt $((lesson + 1)) ] && [ "$ending_lesson" -gt $((lesson - 1)) ]; then
            clear
            tmux send-keys -t basicdemo:main.1 'C-c'
            tmux run -t basicdemo:main.1 echo
            _lesson${lesson}
        fi
    done
}

function demo {
    if [[ "$1" =~ -h|--help|help ]]; then
        cat << EOF
Demonstrates bash lessons.
EOF
        return 0
    fi
    if ! which tmux &> /dev/null; then
        echo "tmux is not installed, please install it and then try again.  (example: brew install tmux, apt-get install tmux, yum install tmux)"
        return 8
    fi
    if tmux has-session -t basicdemo &> /dev/null; then
        echo "Joining the existing session"
        tmux attach -t basicdemo
        tmux select-window -t basicdemo:main
    else
        echo "creating a new basicdemo session"
        tmux new -d -s basicdemo -n main 'basic-bash-demo demo-in-tmux '$*
        tmux split-window -h -t basicdemo:main
        tmux select-pane -t basicdemo:main.0
    fi
    tmux -2 attach-session -d -t basicdemo
}

function basics_main {
    local operation=$1
    shift
    case "$operation" in
        demo) demo $@;;
        demo-in-tmux) demo_in_tmux $@;;
        help|-h|--help|-help)
            cat << EOF
This demonstrates some very powerful bash scripting techniques that are poorly
taught in most other literature.

Parameters:
    demo - runs the main demo.
    help|-h|--help|-help - prints this help.

EOF
            return 0
            ;;
    esac
}

basics_main $@