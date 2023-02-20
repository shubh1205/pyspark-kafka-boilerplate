from time import sleep
from json import dumps
from kafka import KafkaProducer

topic_name= 'test_topic'
producer = KafkaProducer(bootstrap_servers=['localhost:9092'], value_serializer=lambda x: dumps(x).encode('utf-8'))

for e in range(0,26):
    data = {'letters': chr(ord('A')+e)}
    print(data) 
    producer.send(topic_name, value=data)
    sleep(1)