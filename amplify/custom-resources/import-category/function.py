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


log = logging.getLogger(__name__)
log.setLevel('INFO')
log.info(f'Running - {os.getenv('AWS_LAMBDA_FUNCTION_NAME')}')

dyn_resource = boto3.resource("dynamodb")
table = dyn_resource.Table(os.getenv('TABLE_NAME'))

def handler(event, context):
    # Get the S3 bucket and object key from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    # Parse the Excel content into a Pandas dataframe
    df = wr.s3.read_excel(
        f's3://{bucket}/{key}',
        dtype=str
    )
    df = df.fillna('')

    # Process your data (e.g., perform transformations or analysis)    
    # Type,Created,Created By,Deactivated,Email,Phone,First Name,Last Name,Company,Tags,Balance,Payable,Default Split,Terms,Inventory Type,Address Line 1,Address Line 2,City,State,Zip,Number Of Sales,Number Of Items,Last Viewed,Last Activity,Last Item Entered,Last Settlement
    try:
        items =  set()
        for index, row in df.iterrows():
            items.add(Entry('department', row['Category'], row['Created']))
            items.add(Entry('colour', row['Color'], row['Created']))
            items.add(Entry('brand', row['Brand'], row['Created']))
            items.add(Entry('size', row['Size'], row['Created']))
        log.info(f'Number of catogories found: {len(items)}')
        with table.batch_writer() as writer:
            for item in items:
                log.info(f'Putting: {item.toItem()}')
                writer.put_item(Item=item.toItem())

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

class Entry:

    def __init__(self, kind, value, created):
        self.kind = kind
        self.value = value
        self.created = created

    def __eq__(self,other):
        return hash(self) == hash(other)

    def __hash__(self):
        index = str(self.kind) + str(self.value)
        return hash(index)
    
    def toItem(self):
                         

        return {
            'id': str(uuid.uuid4()),
            'type' : self.kind,
            'value': self.value,
            'createdAt': parse(self.created).isoformat(sep='T', timespec='milliseconds') + 'Z',
            'updatedAt': datetime.now(UTC).isoformat(sep='T', timespec='milliseconds').replace('+00:00','Z'),
            '__typename': 'Category',
        }
