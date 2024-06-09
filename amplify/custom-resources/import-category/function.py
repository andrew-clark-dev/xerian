import os
import logging
import pandas as pd
import awswrangler as wr
import uuid
import urllib.parse
import boto3
from datetime import datetime
from datetime import UTC
from dateutil.parser import parse

from botocore.exceptions import ClientError
import truncateTable


log = logging.getLogger(__name__)
log.setLevel('INFO')
log.info(f'Running - {os.getenv('AWS_LAMBDA_FUNCTION_NAME')}')

dyn_resource = boto3.resource("dynamodb")
table = dyn_resource.Table(os.getenv('TABLE_NAME'))

def handler(event, context):
    # Get the S3 bucket and object key from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    # Parse the CSV content into a Pandas dataframe
    df = wr.s3.read_excel(
        f's3://{bucket}/{key}',
        dtype=str
    )
    df = df.fillna('')



    # Process your data (e.g., perform transformations or analysis)
    
    # Type,Created,Created By,Deactivated,Email,Phone,First Name,Last Name,Company,Tags,Balance,Payable,Default Split,Terms,Inventory Type,Address Line 1,Address Line 2,City,State,Zip,Number Of Sales,Number Of Items,Last Viewed,Last Activity,Last Item Entered,Last Settlement
    try:
        items = {}
        with table.batch_writer() as writer:
            for index, row in df.iterrows():
                
                deparment = {
                    'id': str(uuid.uuid4()),
                    'type' : 'department',
                    'value': row['Category'],
                    '__typename': 'Category',
                }
                items[row['Category']+'department'] = deparment
                
                colour = {
                    'id': str(uuid.uuid4()),
                    'type' : 'colour',
                    'value': row['Color'],
                    '__typename': 'Category',
                }
                items[row['Color']+'color'] = colour

                brand = {
                    'id': str(uuid.uuid4()),
                    'type' : 'brand',
                    'value': row['Brand'],
                    '__typename': 'Category',
                }
                items[row['Brand']+'brand'] = brand

                size = {
                    'id': str(uuid.uuid4()),
                    'type' : 'size',
                    'value': row['Size'],
                    '__typename': 'Category',
                }
                items[row['Size']+'size'] = size
            # We have read all the categries, now we delete the current table
            truncateTable(os.getenv('TABLE_NAME'))
            for item in items.values():
                writer.put_item(Item=item)

    except ClientError as err:
        log.error(
            f'Could not load data into table {table.name}. Here is why:{ err.response["Error"]["Code"]}: {err.response["Error"]["Message"]}'
        )
        raise


    # Return any relevant output (e.g., transformed data)
    return {
        'statusCode': 200,
        'body': 'CSV file processed successfully',
    }
