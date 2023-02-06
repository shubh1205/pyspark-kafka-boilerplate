# Pyspark Mongo Boilerplate
This is a boilerplate which has dependencies for pyspark(3.3.0) mongo(>4.x) connectivity

This is built on top of the docker image provided by docker stacks [here](https://hub.docker.com/r/jupyter/pyspark-notebook). 
It involves change to scala version to 2.12 from 2.13 as latest version of mongo-spark-connector(10.0.2) is not compatible with the latter.

## Setup steps
After cloning the repo run following set of commands to get your pyspark jupyter notebook running:

```sh
cd pyspark-mongo-boilerplate # changing directory to the folder where Dockerfile is present
docker build -t pyspark-mongo-base .

run docker without aws creds:
    docker run -p 10000:8888 pyspark-mongo-base

run docker with aws creds:
docker run -e AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID> -e AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY> -e AWS_DEFAULT_REGION=us-west-2 -p 10000:8888 pyspark-mongo-base
```

Output of last command will give you a URL like:
http://127.0.0.1:8888/lab?token=token but our notebook will be running on port 10000 as we have mapped the 8888 port of docker container to 10000 port of host machine so browse to http://127.0.0.1:10000/lab?token=token in browser and **here we go!!**
