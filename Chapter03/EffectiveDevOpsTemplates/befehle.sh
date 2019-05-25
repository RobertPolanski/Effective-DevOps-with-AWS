#!/usr/bin/env bash
aws cloudformation create-stack \
    --capabilities CAPABILITY_IAM \
    --stack-name ansible \
    --template-body file://helloworld-cf-v2.template \
    --parameters ParameterKey=KeyPair,ParameterValue=EffectiveDevOpsAWS



aws ec2 create-security-group \
    --group-name HelloWorld \
    --description "Hello World Demo" \
    --vpc-id vpc-e568218e

aws ec2 authorize-security-group-ingress \
    --group-name HelloWorld \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name HelloWorld \
    --protocol tcp \
    --port 3000 \
    --cidr 0.0.0.0/0

aws ec2 describe-security-groups \
    --group-names HelloWorld \
    --output text