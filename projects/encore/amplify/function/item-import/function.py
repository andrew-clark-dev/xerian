import urllib
import boto3 # type: ignore
from boto3.dynamodb.conditions import Key # type: ignore
import pandas as pd # type: ignore
import numpy as np
import io
import os
import uuid
from decimal import Decimal
from datetime import datetime


import logging

logger = logging.getLogger()
logger.setLevel("INFO")
logger.info("Running account-import function")


# Initialize boto3 client
s3_client = boto3.client("s3")
dynamodb = boto3.client('dynamodb')
dynamodb_res = boto3.resource('dynamodb')

table_name = os.environ.get("ITEM_TABLE_NAME")
table = dynamodb_res.Table(table_name)
logger.info(f"Item Table - {table_name}")
account_table_name = os.environ.get("ACCOUNT_TABLE_NAME")
account_table = dynamodb_res.Table(account_table_name)
logger.info(f"Account Table - {account_table_name}")
category_table_name = os.environ.get("CATEGORY_TABLE_NAME")
brand_table_name = os.environ.get("BRAND_TABLE_NAME")
color_table_name = os.environ.get("COLOR_TABLE_NAME")
size_table_name = os.environ.get("SIZE_TABLE_NAME")
logger.info("Running account-import function")



def handler(event, context):
    # Define S3 bucket and file key
    # Get the S3 bucket and file key from the event
    bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    file_key = urllib.parse.unquote_plus(
        event["Records"][0]["s3"]["object"]["key"], encoding="utf-8"
    )

    try:
        # Get the file from S3
        response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
        status = response.get("ResponseMetadata", {}).get("HTTPStatusCode")

        if status == 200:
            logger.info(f"Successfully retrieved the file from S3. Status - {status}")

            # Read the Excel file into a pandas DataFrame
            file_content = response["Body"].read()
            csv_data = pd.read_csv(io.BytesIO(file_content))
            csv_data = csv_data.replace(np.nan, None)
            # Process each row in the DataFrame
            for index, row in csv_data.iterrows():
                # Example processing: print each row
                logger.info(f"Processing row {index}: {row.to_dict()}")

                # You can replace this with your actual row processing logic
                process_row(row)

                # Uncomment to test for small ammont
                # if index > 10:
                #     return {
                #         "statusCode": 200,
                #         "body": "10 lines processed successfully!",
                #     }

            # Return success message
            return {"statusCode": 200, "body": "File processed successfully!"}
        else:
            logger.error(f"Failed to retrieve the file from S3. Status - {status}")
            return {
                "statusCode": status,
                "body": "Failed to retrieve the file from S3.",
            }
    except Exception as e:
        logger.error(f"Error occurred: {e}")
        return {"statusCode": 500, "body": str(e)}


def process_row(row):

    logger.info(f"Row data: {row.to_dict()}")
    # Mapping row to account object

    createdAt = datetime.strptime(row["Created"], "%Y-%m-%d %H:%M:%S")

    status = "TAGGED"
    if row["Parked"]:
        status = "PARKED"
    if row["Sold"]:
        status = "SOLD"
    
    item_data = {
        "__typename": {"S": "Item"},
        "id": {"S": str(uuid.uuid4())},
        "sku": {"N": str(row["SKU"])},
        "title": {"S": str(row["Title"])},
        "condition": {"S": "UNKNOWN"},
        "split": {"S": str(row["Split"]).replace("%", "")},  # Strp off %
        "price": {"N": str(row["Tag Price"]).replace(",", "")},
        "status": {"S": status},
        "metadata": {"S": row.to_json()},
        "active": {"BOOL": row["Active"]},
        "createdAt": {"S": createdAt.isoformat() + "Z"},
        "updatedAt": {"S": datetime.utcnow().isoformat() + "Z"},
    }

    if row["Category"] is not None:
        item_data["category"] = {"S": row["Category"]}
        category_data = {
            "__typename": {"S": "Category"},
            "name": {"S": row["Category"]},
            "createdAt": {"S": datetime.utcnow().isoformat() + "Z"},
            "updatedAt": {"S": datetime.utcnow().isoformat() + "Z"},
        }
        response = dynamodb.put_item(
            TableName=category_table_name,
            Item=category_data)
        logger.info(f"Category Response : {response}")

    if row["Brand"] is not None:
        item_data["brand"] = {"S": row["Brand"]}
        brand_data = {
            "__typename": {"S": "Brand"},
            "name": {"S": row["Brand"]},
            "createdAt": {"S": datetime.utcnow().isoformat() + "Z"},
            "updatedAt": {"S": datetime.utcnow().isoformat() + "Z"},
        }
        response = dynamodb.put_item(
            TableName=brand_table_name,
            Item=brand_data)
        logger.info(f"Brand Response : {response}")

    if row["Color"] is not None:
        item_data["color"] = {"S": row["Color"]}
        color_data = {
            "__typename": {"S": "Color"},
            "name": {"S": row["Color"]},
            "createdAt": {"S": datetime.utcnow().isoformat() + "Z"},
            "updatedAt": {"S": datetime.utcnow().isoformat() + "Z"},
        }
        response = dynamodb.put_item(
            TableName=color_table_name,
            Item=color_data)
        logger.info(f"Color Response : {response}")

    if row["Size"] is not None:
        item_data["size"] = {"S": row["Size"]}
        size_data = {
            "__typename": {"S": "Size"},
            "name": {"S": row["Size"]},
            "createdAt": {"S": datetime.utcnow().isoformat() + "Z"},
            "updatedAt": {"S": datetime.utcnow().isoformat() + "Z"},
        }
        response = dynamodb.put_item(
            TableName=size_table_name,
            Item=size_data)
        logger.info(f"Size Response : {response}")

    if row["Description"] is not None:
        item_data["description"] = {"S": row["Description"]}
    if row["Details"] is not None:
        item_data["details"] = {"S": row["Details"]}
    if row["Printed"] is not None:
        printedAt = datetime.strptime(row["Printed"], "%Y-%m-%d %H:%M:%S")
        item_data["printedAt"] = {"S": printedAt.isoformat() + "Z"}
    if row["Quantity"] is not None:
        item_data["quantity"] = {"N": str(row["Quantity"])}
    else:
        item_data["quantity"] = {"N": "0"}
        
    # Now let us connect the Account, first query on the secondary index we have created for number
    accountResponse = account_table.query(
        IndexName='accountsByNumber',
        KeyConditionExpression=Key('number').eq(row["Account"])
    )
    logger.info(f"accountResponse : {accountResponse}")


    items = accountResponse.get('Items')
    account = items[0] if len(items) > 0 else None

    if account is not None:
        logger.info(f"Bind to Account : {account["number"]}, id : {account["id"]}")
        item_data["accountId"] =  {"S": account["id"]}
        item_data["accountNumber"] =  {"S": str(account["number"])}

    logger.info(f"Item data: {item_data}")

    # Perform upsert operation
    response = dynamodb.put_item(
        TableName=table_name,
        Item=item_data)

    logger.info(f"Item Response : {response}")
