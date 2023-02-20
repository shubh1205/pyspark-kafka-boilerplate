import json
from sseclient import SSEClient as EventSource
from kafka import KafkaProducer

# Create producer
producer = KafkaProducer(
    bootstrap_servers='localhost:9092', #Kafka server
    value_serializer=lambda v: json.dumps(v).encode('utf-8') #json serializer
    )

# Read streaming event
url = 'https://stream.wikimedia.org/v2/stream/recentchange'
try:
    for event in EventSource(url):
        if event.event == 'message':
            try:
                change = json.loads(event.data)
            except ValueError:
                pass
            else:
                #Send msg to topic wiki-changes
                producer.send('test_streaming_topic', change)

except KeyboardInterrupt:
    print("process interrupted")