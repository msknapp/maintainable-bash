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