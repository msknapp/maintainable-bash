#!/usr/bin/env bash

# when writing a file
echo "testing" > $HOME/my-test

# when installing a program
apt-get install docker

# when pushing a resource
docker push my-image:1

# when invoking an API
curl -X POST https://mydata.com/record -d '{"id":"1"}'

# writing to S3...
aws s3 cp myfile s3://mybucket/myfile

# posting to K8s...
kubectl apply -f my-deployment.yaml