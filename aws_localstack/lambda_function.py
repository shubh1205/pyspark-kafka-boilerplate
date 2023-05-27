
import boto3
import logging

s3_client = boto3.client('s3')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        # Example: Read a file from S3
        bucket_name = 'aman2404'
        file_key = 'example.csv'
        
        response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
        file_contents = response['Body'].read().decode('utf-8')
        
        # Process the file contents
        # Example: Print the file contents
        logger.info(file_contents)
        
        return {
            'statusCode': 200,
            'body': 'File processed successfully'
        }
    except Exception as e:
        logger.error(f'Error: {str(e)}')
        return {
            'statusCode': 500,
            'body': 'Error processing the file'
        }

