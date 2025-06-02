import os
import uuid
import json
import logging
from typing import Any, Dict

import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ACTION_TABLE = os.environ.get("ACTION_TABLE")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(ACTION_TABLE)

# Add for total table
TOTAL_TABLE = os.environ.get("TOTAL_TABLE")
total_table = dynamodb.Table(TOTAL_TABLE)


class DynamoService:
    def __init__(self, table_name: str):
        self.table = dynamodb.Table(table_name)

    def write(self, item: Dict[str, Any]):
        self.table.put_item(Item=item)


dynamo_service = DynamoService(ACTION_TABLE)

def lambda_handler(event, context):
    logger.info("DynamoDBStreamEvent: %s", json.dumps(event))

    for record in event.get("Records", []):
        logger.info("Processing Event Type: %s - record: %s", record.get("eventName"), json.dumps(record))
        try:
            if record["eventName"] == "INSERT":
                new_image = record["dynamodb"]["NewImage"]
                model_name = new_image["__typename"]["S"]
                logger.info("New %s Image: %s", model_name, json.dumps(new_image))

                dynamo_service.write({
                    "__typename": "Action",
                    "id": str(uuid.uuid4()),
                    "type": "Create",
                    "typeIndex": "Create",
                    "description": f"Created {model_name} - (auto-log)",
                    "userId": new_image["lastActivityBy"]["S"],
                    "modelName": model_name,
                    "refId": new_image["id"]["S"],
                    "after": json.dumps(new_image)
                })

                # Increment the total table's val column atomically
                total_table.update_item(
                    Key={"name": model_name},
                    UpdateExpression="ADD val :inc",
                    ExpressionAttributeValues={":inc": 1},
                )

            elif record["eventName"] == "MODIFY":
                new_image = record["dynamodb"]["NewImage"]
                old_image = record["dynamodb"]["OldImage"]
                model_name = new_image["__typename"]["S"]

                logger.info("New %s Image: %s", model_name, json.dumps(new_image))
                logger.info("Old %s Image: %s", model_name, json.dumps(old_image))

                dynamo_service.write({
                    "__typename": "Action",
                    "id": str(uuid.uuid4()),
                    "type": "Update",
                    "typeIndex": "Update",
                    "description": f"Updated {model_name} - (auto-log)",
                    "userId": new_image["lastActivityBy"]["S"],
                    "modelName": model_name,
                    "refId": new_image["id"]["S"],
                    "before": json.dumps(old_image),
                    "after": json.dumps(new_image)
                })

        except Exception as e:
            new_image = record["dynamodb"].get("NewImage", {})
            logger.error("Errors in creating action for %s %s, id: %s - %s",
                         record["eventName"],
                         new_image.get("__typename", {}).get("S", "Unknown"),
                         new_image.get("id", {}).get("S", "Unknown"),
                         str(e))

    logger.info("Successfully processed %d records.", len(event.get("Records", [])))