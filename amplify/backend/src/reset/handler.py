import boto3
import os

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

# Constant list of items to upsert
ITEMS = [
    {'id': '1', 'name': 'Item 1', 'status': 'active'},
    {'id': '2', 'name': 'Item 2', 'status': 'inactive'},
    {'id': '3', 'name': 'Item 3', 'status': 'pending'},
]

def handler(event, context):
    with table.batch_writer(overwrite_by_pkeys=['id']) as batch:
        for item in ITEMS:
            batch.put_item(Item=item)

    return {
        'statusCode': 200,
        'body': f'Upserted {len(ITEMS)} items into table {table_name}'
    }