#!/usr/bin/env bash
set -x

setXUpdated() { x=updated; }
exportXUpdated() { export x=updated; }
say_x() { echo "${x:-original}"; }
setXLocal() { local x=updated; say_x }

x=original
( x=updated )
echo $x # original
: | x=updated
echo $x # original
: | { x=updated; echo $x; } # updated
echo $x # original
bash -c 'x=updated'
echo $x # original
{ x=updated }
echo $x # updated
x=original
( setXUpdated )
echo $x # original
: | setXUpdated
echo $x # original
setXUpdated
echo $x # updated
x=original
( exportXUpdated )
echo $x # original
: | exportXUpdated
echo $x # original
exportXUpdated
echo $x # updated

cat > /tmp/make_x_updated.sh << EOF
#!/usr/bin/env bash
x=updated
EOF
bash /tmp/make_x_updated.sh
echo $x # original
source /tmp/make_x_updated.sh
echo $x # updated
x=original
. /tmp/myscript.sh
echo $x # updated
x=updated
say_x() # updated
( say_x ) # original
: | say_x # original
export x=updated
( say_x ) # updated
: | say_x # updated
x=original
setXLocal # original

set +x