#!/usr/bin/env bash

aws iam create-role \
  --role-name CodeDeployServiceRole \
  --assume-role-policy-document file://CodeDeployTrust.json

aws iam attach-role-policy \
  --role-name CodeDeployServiceRole \
  --policy-arn \
  arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole


aws cloudformation create-stack \
  --capabilities CAPABILITY_IAM \
  --stack-name jenkins \
  --template-body file://jenkins-cf.template \
  --parameters ParameterKey=KeyPair,ParameterValue=EffectiveDevOpsAWS


aws cloudformation describe-stacks \
  --stack-name helloworld-staging \
  --query 'Stacks[0].Outputs[0].OutputValue' \
  | xargs -I {} curl {}:3000




aws cloudformation create-stack \
  --capabilities CAPABILITY_IAM \
  --stack-name helloworld-staging \
  --template-body file://nodeserver-cf.template \
  --parameters ParameterKey=KeyPair,ParameterValue=EffectiveDevOpsAWS


aws cloudformation create-stack \
  --capabilities CAPABILITY_IAM \
  --stack-name helloworld-production \
  --template-body file://nodeserver.template \
  --parameters ParameterKey=KeyPair,ParameterValue=EffectiveDevOpsAWS

aws cloudformation wait stack-create-complete \
  --stack-name helloworld-production



# create ne deployment group:

arn=$(aws deploy get-deployment-group \
  --application-name helloworld \
  --deployment-group-name staging \
  --query 'deploymentGroupInfo.serviceRoleArn')

aws deploy create-deployment-group \
  --application-name helloworld \
  --ec2-tag-filters Key=aws:cloudformation:stack-name,Type=KEY_AND_VALUE,Value=helloworld-production \
  --deployment-group-name production \
  --service-role-arn $arn

aws deploy list-deployment-groups \
  --application-name helloworld


# Simple notification service
aws sns create-topic --name production-deploy-approval


aws sns subscribe --topic-arn \
  arn:aws:sns:eu-central-1:632453688368:production-deploy-approval \
  --protocol email \
  --notification-endpoint rpolanskii@gmail.com


