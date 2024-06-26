# Pyspark Kafka Boilerplate with AWS and Azure CLI
This is a boilerplate which has dependencies for pyspark(3.3.0), Kafka(3.3.2) and mongo(>4.x) connectivity

This is built on top of the docker image provided by docker stacks [here](https://hub.docker.com/r/jupyter/pyspark-notebook). 
It involves change to scala version to 2.12 from 2.13 as latest version of mongo-spark-connector(10.0.2) is not compatible with the latter.

## Setup steps
If you just want to use Spark or Kafka without localstack After cloning the repo run following set of commands to get your pyspark jupyter notebook running:

```sh
cd pyspark-mongo-boilerplate # changing directory to the folder where Dockerfile is present
docker build -t pyspark-mongo-base .

run docker:
    docker run -p 10000:8888 -p 4040:4040 pyspark-mongo-base

run docker with aws creds:
    docker run -e AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID> -e AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY> -e AWS_DEFAULT_REGION=us-west-2 -p 10000:8888 pyspark-mongo-base

run docker with azure creds:
    docker run -e AZURE_TENANT_ID=<TENANT_ID> -e AZURE_CLIENT_ID=<CLIENT_ID> -e AZURE_CLIENT_SECRET=<CLIENT_SECRET> -p 10000:8888 pyspark-mongo-base
```

If you want use it with localstack run following set of command:

```sh
cd pyspark-mongo-boilerplate # changing directory to the folder where Dockerfile is present
docker compose up
```

Output of last command will give you a URL like:
http://127.0.0.1:8888/lab?token=<--token--> but our notebook will be running on port 10000 as we have mapped the 8888 port of docker container to 10000 port of host machine so browse to http://127.0.0.1:10000/lab?token=<--token--> in browser, Spark UI URL: Since we've mapped port 4040 of the Docker container to port 4040 of the host machine, you can access the Spark UI at http://127.0.0.1:4040 in your browser and **here we go!!**
