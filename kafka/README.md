# Pyspark Mongo Boilerplate
This is a boilerplate which has dependencies for pyspark(3.3.0) kafka(>3.x) connectivity

It involves change to scala version to 2.12 from 2.13 as latest version of kafka(3.3.2) is not compatible with the latter.

After completing the setup mention previously.

## Steps to testing Kafka
```
open terminal in jupyter lab, run bellow commands in different terminals

/usr/local/kafka_2.12-3.3.2/bin/zookeeper-server-start.sh /usr/local/kafka_2.12-3.3.2/config/zookeeper.properties

/usr/local/kafka_2.12-3.3.2/bin/kafka-server-start.sh /usr/local/kafka_2.12-3.3.2/config/server.properties

Run producer using:
python producer.py

Consume data using:
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test_topic --from-beginning
``` 

**here we go!!**
