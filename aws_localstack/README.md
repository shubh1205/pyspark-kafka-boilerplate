## Setup steps for localstack
Run this command -> docker compose up
Then open Docker in your machine and you can see the container that
will contain two container .
Pyspark-mongo base
and localstack

Default creds for AWS for localstack
AWS Access Key ID: test
AWS Secret Access Key: test
AWS Default Region: us-east-1

steps to create s3 bucket ;
```
aws --endpoint-url=http://localhost:4566 s3 mb s3://your-bucket-name
```
This command uses the create-bucket API of the AWS CLI and specifies the LocalStack endpoint URL using the --endpoint-url option.

To check the list of buckets;
```
aws --endpoint-url=http://localhost:4566 s3 ls
```
TO UPLOAD CSV FILE SAVED IN LOCAL TO THIS BUCKET YOU CAN USE THIS COMMAND.
```
aws s3api put-object --bucket my-bucket --key example.csv --body example.csv --endpoint-url http://localhost:4566
```
or
```
aws --endpoint-url=http://localhost:4566 s3 cp example.csv s3://your-bucket-name
```

Create a IAM role for lambda 
```
aws --endpoint-url=http://localhost:4566 iam create-role --role-name lambda-execution-role --assume-role-policy-document file://trust-policy.json
```
attach policy to role
```
aws --endpoint-url=http://localhost:4566 iam put-role-policy --role-name lambda-execution-role --policy-name s3-access-policy --policy-document file://role-policy.json
```

create a lambda function
```
aws --endpoint-url=http://localhost:4566 lambda create-function --function-name your-function --runtime python3.8 --role arn:aws:iam::000000000000:role/lambda-execution-role --handler lambda_function.lambda_handler --zip-file fileb:/lambda_function.zip
```
invoke lambda function 
```
aws lambda invoke --function-name your-function --endpoint-url=http://localhost:4566 output.json
```
watch logs 
```
aws logs describe-log-streams --log-group-name /aws/lambda/you-function --endpoint-url=http://localhost:4566
```