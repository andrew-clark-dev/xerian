import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";
import { S3Event, Context } from "aws-lambda";
import { GetObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { parse } from 'csv-parse';
import { Readable } from "stream";

const s3Client = new S3Client({});
const dynamoDBClient = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(dynamoDBClient);

import { randomUUID } from "crypto";
export const handler = async (event: S3Event, context: Context) => {

    const bucketName = event.Records[0].s3.bucket.name;
    const objectKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
    console.log('Processing event:', event);
    console.log('Target table:', process.env.table_name);


    try {
        const getObjectParams = { Bucket: bucketName, Key: objectKey };
        const s3command = new GetObjectCommand(getObjectParams);
        const response = await s3Client.send(s3command);
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
                        console.log("Record:", record);
                        var item: any = {
                            id: randomUUID(),
                            address: record["Address Line 1"],
                            city: record.City,
                            createdAt: new Date(record.Created).toISOString(),
                            phoneNumber: record.Phone,
                            email: record.Email,
                            firstName: record["First Name"],
                            lastName: record["Last Name"],
                            number: record.Number,
                            postcode: record.Zip,
                            state: record.State,
                            updatedAt: new Date().toISOString(),
                            __typename: "Account"
                        }

                        if (record["Address Line 2"] != "") item.address += "\n" + record["Address Line 2"];

                        const balence = parseFloat(record["Balence"]);
                        if (!isNaN(balence)) { item.balence = balence }
                        const split = parseFloat(record["Default Split"]);
                        if (!isNaN(balence)) { item.split = split }
                        // split: parseFloat(record["Default Split"]),
                        const putCommand = new PutCommand({
                            TableName: process.env.table_name,
                            Item: item
                        });
                        console.log("Create new account:", putCommand);
                        const response: any = await docClient.send(putCommand).catch(error => console.error("Error:", error));
                        console.log("Response:", response);

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
    } catch (err) {
        console.error(err);
    }

};