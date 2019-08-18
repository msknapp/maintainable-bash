#!/bin/bash

# Part 3: rewrite the "bad-example" shell script using all the best practices I recommended
# in the presentation.
# 1.  Have one main function that routes to sub-commands
# 2.  Use functions for all code except the line that calls the main function.
# 3.  all functions must support named parameters, have help documentation, and support both a debug and dry-run mode.
# 4.  Check assumptions, fail early if they are not met.
# 5.  Use status codes.
# 6.  Write log information to std err.

export CONTEXT=$1

echo "The following nodes are not ready:"
kubectl ${CONTEXT} get nodes --no-headers | grep -v Ready

echo "The following pods are malfunctioning."
kubectl ${CONTEXT} get po --all-namespaces --no-headers | grep -vE "(Running|Completed)"

if [ "`kubectl ${CONTEXT} my_namespace get sts hadoop`" -lt 2 ]; then
    echo "hadoop is not deployed"
    exit
fi

if [ "`kubectl ${CONTEXT} my_namespace get sts mongo`" -lt 2 ]; then
    echo "mongo is not deployed"
    exit
fi

if [ "`kubectl ${CONTEXT} my_namespace get deploy apache`" -lt 2 ]; then
    echo "apache is not deployed"
    exit
fi

pods=`kubectl get po --all-namespaces | grep -v Name | cut -d' ' -f1`
for pod in $pods; do
    errors=`kubectl ${CONTEXT} logs "${pod}" | grep Error`
    if [ "`echo $errors | wc -l`" -gt 0 ]; then
        echo "There are errors in the logs of pod $pod"
    fi
done
