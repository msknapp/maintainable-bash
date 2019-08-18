#!/usr/bin/env bash

square() {
    echo -n "$((square * square))"
}
run() {
    three_squared=$(square 3)
    echo "3 squared is: $three_squared"
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
