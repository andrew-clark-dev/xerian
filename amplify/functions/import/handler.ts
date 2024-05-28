import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { S3Event, Context } from "aws-lambda";
import { Readable } from "stream";
import { parse } from 'csv-parse';
var uuid = require('uuid');

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

        const processFile = async () => {
            const records = [];
            const parser = stream
                .pipe(parse({
                    // CSV options if any
                }));
            for await (const record of parser) {
                // Work with each record
                records.push(record);
            }
            return records;
        };

        (async () => {
            const records = await processFile();
            console.info(records);
        })();

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
