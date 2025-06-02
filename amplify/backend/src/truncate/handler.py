import boto3

dynamodb = boto3.resource('dynamodb')

def handler(event, context):
    table_name = event.get('tableName')
    if not table_name:
        return {
            'statusCode': 400,
            'body': 'Missing required "tableName" in event'
        }

    table = dynamodb.Table(table_name)

    scan = table.scan(ProjectionExpression='#k', ExpressionAttributeNames={'#k': 'id'})
    with table.batch_writer() as batch:
        for item in scan['Items']:
            batch.delete_item(Key={'id': item['id']})

    while 'LastEvaluatedKey' in scan:
        scan = table.scan(
            ProjectionExpression='#k',
            ExpressionAttributeNames={'#k': 'id'},
            ExclusiveStartKey=scan['LastEvaluatedKey']
        )
        with table.batch_writer() as batch:
            for item in scan['Items']:
                batch.delete_item(Key={'id': item['id']})

    return {
        'statusCode': 200,
        'body': f'Truncated table {table_name}'
    }