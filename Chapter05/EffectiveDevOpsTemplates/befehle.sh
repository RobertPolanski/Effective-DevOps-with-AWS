
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





aws cloudformation create-stack \
  --capabilities CAPABILITY_IAM \
  --stack-name helloworld-staging \
  --template-body file://nodeserver-cf.template \
  --parameters ParameterKey=KeyPair,ParameterValue=EffectiveDevOpsAWS