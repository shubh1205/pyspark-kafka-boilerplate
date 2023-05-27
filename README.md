# Pyspark Kafka Boilerplate with AWS and Azure CLI
This is a boilerplate which has dependencies for pyspark(3.3.0), Kafka(3.3.2) and mongo(>4.x) connectivity

This is built on top of the docker image provided by docker stacks [here](https://hub.docker.com/r/jupyter/pyspark-notebook). 
It involves change to scala version to 2.12 from 2.13 as latest version of mongo-spark-connector(10.0.2) is not compatible with the latter.

## Setup steps
After cloning the repo run following set of commands to get your pyspark jupyter notebook running:

```sh
cd pyspark-mongo-boilerplate # changing directory to the folder where Dockerfile is present
docker build -t pyspark-mongo-base .

run docker:
    docker run -p 10000:8888 pyspark-mongo-base

run docker with aws creds:
    docker run -e AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID> -e AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY> -e AWS_DEFAULT_REGION=us-west-2 -p 10000:8888 pyspark-mongo-base

run docker with azure creds:
    docker run -e AZURE_TENANT_ID=<TENANT_ID> -e AZURE_CLIENT_ID=<CLIENT_ID> -e AZURE_CLIENT_SECRET=<CLIENT_SECRET> -p 10000:8888 pyspark-mongo-base
```

Output of last command will give you a URL like:
http://127.0.0.1:8888/lab?token=<--token--> but our notebook will be running on port 10000 as we have mapped the 8888 port of docker container to 10000 port of host machine so browse to http://127.0.0.1:10000/lab?token=<--token--> in browser and **here we go!!**

Run this command -> docker compose up
Than open Docker in your machine and you can see the container that
will contain two container .
Pyspark-mongo base
This will run on port 10000
localstack

Default creds for AWS for localstack
AWS Access Key ID: test
AWS Secret Access Key: test
AWS Default Region: us-east-1

steps to create s3 bucket ;

aws --endpoint-url=http://localhost:4566 s3 mb s3://your-bucket-name

This command uses the create-bucket API of the AWS CLI and specifies the LocalStack endpoint URL using the --endpoint-url option.

To check the list of buckets;

aws --endpoint-url=http://localhost:4566 s3 ls

TO UPLOAD CSV FILE SAVED IN LOCAL TO THIS BUCKET YOU CAN USE THIS COMMAND.

aws s3api put-object --bucket my-bucket --key example.csv --body example.csv --endpoint-url http://localhost:4566
or
aws --endpoint-url=http://localhost:4566 s3 cp example.csv s3://your-bucket-name


Create a IAM role for lambda 

aws --endpoint-url=http://localhost:4566 iam create-role --role-name lambda-execution-role --assume-role-policy-document file://trust-policy.json

attach policy to role

aws --endpoint-url=http://localhost:4566 iam put-role-policy --role-name lambda-execution-role --policy-name s3-access-policy --policy-document file://C:/Users/coditas/Desktop/role-policy.json


create a lambda function

aws --endpoint-url=http://localhost:4566 lambda create-function --function-name your-function --runtime python3.8 --role arn:aws:iam::000000000000:role/lambda-execution-role --handler lambda_function.lambda_handler --zip-file fileb:/lambda_function.zip

invoke lambda function 

aws lambda invoke --function-name your-function --endpoint-url=http://localhost:4566 output.json

watch logs 

aws logs describe-log-streams --log-group-name /aws/lambda/you-function --endpoint-url=http://localhost:4566