#!/usr/bin/env bash

function act {
    echo "stdout"
    echo "stderr" 1>&2
}

pp=/tmp/myfifo
echo "making the fifo"
[ ! -p "$pp" ] && mkfifo -m 664 $pp
echo "made the fifo"
out=$(act 2>> /tmp/myfifo)
echo "ran the action"
err=$(cat $pp)

echo "out is: $out"
echo "err is: $err"