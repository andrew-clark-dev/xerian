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
from decimal import Decimal

log = logging.getLogger(__name__)
log.setLevel('INFO')
log.info(f'Running - {os.getenv('AWS_LAMBDA_FUNCTION_NAME')}')

dyn_resource = boto3.resource("dynamodb")
table = dyn_resource.Table(os.getenv('ACCOUNT_TABLE'))

def handler(event, context):
    # Get the S3 bucket and object key from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    # Parse the Excel content into a Pandas dataframe
    df = wr.s3.read_excel(
        f's3://{bucket}/{key}',
        dtype="string"
    )
    log.info(f'Dtypes - {df.dtypes}')
    df = df.fillna('')

    # Process your data (e.g., perform transformations or analysis)
    
    # Number,Created,Created By,Deactivated,Email,Phone,First Name,Last Name,Company,Tags,Balance,Payable,Default Split,Terms,Inventory Type,Address Line 1,Address Line 2,City,State,Zip,Number Of Sales,Number Of Items,Last Viewed,Last Activity,Last Item Entered,Last Settlement
    try:
        with table.batch_writer() as writer:
            for index, row in df.iterrows():
                log.info(f'Row - {row}')
                phone = phoneNumber(row)
                item = {
                    'id': str(uuid.uuid4()),
                    'address' : address(row),
                    'city': row['City'],
                    'createdAt': parse(row['Created']).isoformat(sep='T', timespec='milliseconds') + 'Z',
                    'phoneNumber': phone,
                    'isMobile': phone.startswith('07'), 
                    'email': row['Email'],
                    'firstName': row['First Name'],
                    'lastName': row['Last Name'],
                    'number': row['Number'],
                    'postcode': row['Zip'],
                    'state': row['State'],
                    'balence': balence(row),
                    'updatedAt': datetime.now(UTC).isoformat(sep='T', timespec='milliseconds').replace('+00:00','Z'),
                    'adprefs': 'none',
                    'status': status(row),
                    'original': row.to_json(),
                    '__typename': 'Account',

                }
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


def address(row):
    result = row['Address Line 1']
    if (row['Address Line 2'] != ''): 
        result += '\n' + row['Address Line 2'];
    return result

def balence(row):
    try:
        return Decimal(row['Balance'])
    except ValueError:
        return Decimal(0)

def status(row):
    if row['Deactivated'] == '':
        return 'active'
    return 'inactive'

def phoneNumber(row):
    result = row['Phone']
    # First remove spaces.
    result = result.replace(' ', '')
    # Replace +41 with 0 , for Swiss numbers
    result = result.replace('+41', '0')
    # Replace 0041 with 0 , for Swiss numbers
    result = result.replace('0041', '0')
    # Special case if 417 this is very likely a 07 ..
    result = result.replace('417', '07')
    return result