import findspark
from pyspark.sql import SparkSession
from pyspark.sql.functions import to_json, struct, from_json, col, split
from pyspark.sql.types import StructType, StructField, StringType
import time

scala_version = '2.12'
spark_version = '3.3.0'
# TODO: Ensure match above values match the correct versions
packages = [
    f'org.apache.spark:spark-sql-kafka-0-10_{scala_version}:{spark_version}',
    'org.apache.kafka:kafka-clients:3.3.2'
]
spark = SparkSession.builder\
   .master("local")\
   .appName("kafka-example")\
   .config("spark.jars.packages", ",".join(packages))\
   .getOrCreate()

df = spark \
  .readStream \
  .format("kafka") \
  .option("kafka.bootstrap.servers", "localhost:9092") \
  .option("subscribe", "test_streaming_topic") \
  .option("startingOffsets", "latest") \
  .load()

df = df.selectExpr("CAST(value AS STRING)")

time.sleep(2)
qName = 'streaming_data'

try:
    writing_sink = df.writeStream \
        .format("json") \
        .option("path", "./output/") \
        .option("checkpointLocation", "./output/") \
        .option("maxRecordsPerFile", 1000) \
        .start()
    writing_sink.awaitTermination()
except:
    print('Process stopped after 10sec')
