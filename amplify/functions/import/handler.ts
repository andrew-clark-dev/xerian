import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { S3Event, Context } from "aws-lambda";
import { Readable } from "stream";
import { parse } from 'csv-parse';
var uuid = require('uuid');
import { env } from '$amplify/env/on-upload-handler'; // the import is '$amplify/env/<function name>'

const s3Client = new S3Client({});
const dynamoDBClient = new DynamoDBClient({});

export const handler = async (event: S3Event, context: Context): Promise<string> => {
    const bucketName = event.Records[0].s3.bucket.name;
    const objectKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));

    try {
        const getObjectParams = { Bucket: bucketName, Key: objectKey };
        const command = new GetObjectCommand(getObjectParams);
        const response = await s3Client.send(command);
        const stream = response.Body as Readable;


        // Create a promise to process all lines
        await new Promise<void>((resolve, reject) => {
            stream
                .pipe(
                    parse(
                        {
                            columns: true
                        }
                    ))
                .on('data', async (record: any) => {
                    try {
                        // Work with each record


                        const item = {
                            "id": {
                                "S": uuid.v1()
                            },
                            "address": {
                                "S": record['Address Line 1'] + '\n' + record['Address Line 2']
                            },
                            "city": {
                                "S": record.City
                            },
                            "createdAt": {
                                "S": record.Created
                            },
                            "email": {
                                "S": record.Email
                            },
                            "firstName": {
                                "S": record['First Name']
                            },
                            "lastName": {
                                "S": record['Last Name']
                            },
                            "number": {
                                "S": record.Number
                            },
                            "phoneNumber": {
                                "S": record.Phone
                            },
                            "postcode": {
                                "S": record.Zip
                            },
                            "split": {
                                "S": record['Default Split']
                            },
                            "state": {
                                "S": record.State
                            },
                            "updatedAt": {
                                "S": new Date().toISOString()
                            },
                            "__typename": {
                                "S": "Account"
                            }
                        };

                        const result = await dynamoDBClient.send(
                            new PutItemCommand({
                                TableName: process.env.table_name,
                                Item: item
                            })
                        );
                    } catch (error) {
                        console.error('Error writing to DynamoDB:', error);
                        reject(error);
                    }
                })

                .on('end', () => {
                    resolve();
                })

                .on('error', (error) => {
                    console.error('Error reading CSV:', error);
                    reject(error);
                });

        });
        return `Successfully processed ${objectKey}`;
    } catch (error: unknown) {
        if (error instanceof Error) {
            console.error('Error processing S3 event:', error.message);
            throw new Error(`Error processing S3 event: ${error.message}`);
        } else {
            console.error('Unknown error:', error);
            throw new Error('An unknown error occurred.');
        }
    }
};
