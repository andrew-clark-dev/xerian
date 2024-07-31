import urllib
import boto3  # type: ignore
import pandas as pd  # type: ignore
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
dynamodb = boto3.client("dynamodb")
table_name = os.environ.get("ACCOUNT_TABLE_NAME")


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
    item_data = {
        "__typename": {"S": "Account"},
        "id": {"S": str(uuid.uuid4())},
        "number": {"N": str(row["Number"])},
        "balance": {"N": str(row["Balance"]).replace(",", "")},
        "comunicationPreferences": {"S": "none"},
        "status": {"S": "active"},
        "category": {"S": "standard"},
        "metadata": {"S": row.to_json()},
        "createdAt": {"S": createdAt.isoformat() + "Z"},
        "updatedAt": {"S": datetime.utcnow().isoformat() + "Z"},
    }

    if row["First Name"] is not None:
        item_data["firstName"] = {"S": row["First Name"]}
    if row["Last Name"] is not None:
        item_data["lastName"] = {"S": row["Last Name"]}
    if row["Phone"] is not None:
        item_data["phoneNumber"] = {"S": row["Phone"]}
    if row["City"] is not None:
        item_data["city"] = {"S": row["City"]}
    if row["State"] is not None:
        item_data["state"] = {"S": row["State"]}
    if row["Zip"] is not None:
        item_data["postcode"] = {"S": row["Zip"]}

    # Ugly but it works to get the address
    address = None
    if row["Address Line 1"] is not None:
        address = row["Address Line 1"]
        if row["Address Line 2"] is not None:
            address = address + "\n" + row["Address Line 2"]
    else:
        if row["Address Line 2"] is not None:
            address = row["Address Line 2"]
    if address is not None:
        item_data["address"] = {"S": address}

    # Perform upsert operation
    response = dynamodb.put_item(
        TableName=table_name,
        Item=item_data,
        ConditionExpression="attribute_not_exists(#number)",  # Only insert if the number key doesn't exist
        ExpressionAttributeNames={"#number": "number"},
    )

    logger.info(f"Respnse : {response}")
