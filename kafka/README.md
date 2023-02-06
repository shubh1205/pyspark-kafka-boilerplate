# Pyspark Kafka Boilerplate
This is a boilerplate which has dependencies for pyspark(3.3.0) kafka(>3.x) connectivity

It involves change to scala version to 2.12 from 2.13 as latest version of kafka(3.3.2) is not compatible with the latter.

After completing the setup mention previously.

## Steps for testing Kafka
Upload the code files into jupter-lab (consumer.py, producer.py, stream_consumer.py & stream_producer.py).

Run
```
run: pip install kafka-python
```

open terminal in jupyter lab, run bellow commands each, in separate terminals.
```
/usr/local/kafka_2.12-3.3.2/bin/zookeeper-server-start.sh /usr/local/kafka_2.12-3.3.2/config/zookeeper.properties

/usr/local/kafka_2.12-3.3.2/bin/kafka-server-start.sh /usr/local/kafka_2.12-3.3.2/config/server.properties
```

#### Kafka with python:
Run producer using  python script:
```
    python producer.py
```
Consume data using python script:
```
    python consumer.py
```
Output will be visible on terminal.

#### Kafka streaming with pyspark:
Produce streaming data using pyspark script:
```
    python stream_producer.py
```
Consume streaming data using pyspark script:
```
    python stream_consumer.py
```
Folder called "output", will be created in same folder.

Consume data using kafka sh:
```
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test_topic --from-beginning
``` 

**here we go!!**
