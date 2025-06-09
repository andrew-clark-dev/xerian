import boto3
import json
import os
import logging

dynamodb = boto3.resource('dynamodb')
logger = logging.getLogger()

def truncate_table(table_name: str, key_name: str):
    table = dynamodb.Table(table_name)

    scan = table.scan(ProjectionExpression='#k', ExpressionAttributeNames={'#k': key_name})
    with table.batch_writer() as batch:
        for item in scan['Items']:
            batch.delete_item(Key={key_name: item[key_name]})

    while 'LastEvaluatedKey' in scan:
        scan = table.scan(
            ProjectionExpression='#k',
            ExpressionAttributeNames={'#k': key_name},
            ExclusiveStartKey=scan['LastEvaluatedKey']
        )
        with table.batch_writer() as batch:
            for item in scan['Items']:
                batch.delete_item(Key={key_name: item[key_name]})

def lambda_handler(event, context):
    logger.info("TruncateEvent: %s", json.dumps(event))

    envVar = event.get('modelName') + "_TABLE_NAME"

    table_name = os.environ.get(envVar)
    key_name = event.get('keyName')
    truncate_table(table_name, key_name)

    # Get total table
    TOTAL_TABLE_NAME = os.environ.get("TOTAL_TABLE_NAME")
    total_table = dynamodb.Table(TOTAL_TABLE_NAME)

    # Reset the total table's val column
    total_table.put_item(Item={
            "__typename": "Total",
            "name": event.model_name,
            "val": 0
        })
    
    logger.info("Successfully truncated %s .", table_name)

    return event.get('modelName')