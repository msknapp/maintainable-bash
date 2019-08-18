#!/usr/bin/env bash

# when writing a file
[ ! -f $HOME/my-test ] && echo "testing" > $HOME/my-test

# when installing a program
! which docker &> /dev/null && apt-get install docker

# when pushing a resource
docker push my-image:1

# when invoking an API
if ! curl https://mydata.com/record?id=1 &> /dev/null ; then
    curl -X POST https://mydata.com/record -d '{"id":"1"}'
fi

# writing to S3...
if ! aws s3 ls s3://mybucket/myfile &> /dev/null ; then
    aws s3 cp myfile s3://mybucket/myfile
fi

# posting to K8s...
if ! kubectl get deploy my-deployment &> /dev/null ; then
    kubectl apply -f my-deployment.yaml
fi