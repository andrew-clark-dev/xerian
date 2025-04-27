import type { DynamoDBBatchItemFailure, DynamoDBStreamHandler } from "aws-lambda";
import { type Schema } from "../../data/resource";
import { generateClient } from "aws-amplify/data";
import { Amplify } from "aws-amplify";
import { getAmplifyDataClientConfig } from '@aws-amplify/backend/function/runtime';
import AWS from 'aws-sdk';
import { env } from "$amplify/env/create-action-function";
import { logger } from "@backend/services/logger";

const { resourceConfig, libraryOptions } = await getAmplifyDataClientConfig(
    env
);

Amplify.configure(resourceConfig, libraryOptions);

const client = generateClient<Schema>();


const dynamoDb = new AWS.DynamoDB.DocumentClient();


export const handler: DynamoDBStreamHandler = async (event) => {
    logger.info('DynamoDBStreamEvent', event);
    const fail: DynamoDBBatchItemFailure[] = [];

    for (const record of event.Records) {
        logger.info(`Processing Event Type: ${record.eventName} - record: ${JSON.stringify(record)}`);
        try {

            if (record.eventName === "INSERT") {
                // business logic to process new records
                const newImage = record.dynamodb!.NewImage!;
                const modelName = newImage.__typename.S;
                logger.info(`New ${modelName} Image: ${JSON.stringify(newImage)}`);
                const { errors } = await client.models.Action.create({
                    type: "Create",
                    typeIndex: "Create",
                    description: `Created ${modelName} - (auto-log)`,
                    userId: newImage.lastActivityBy.S,
                    modelName: modelName,
                    refId: newImage.id.S,
                    after: JSON.stringify(newImage)
                });

                logger.ifErrorThrow('Failed to create insert action', errors);

                try {
                    const params = {
                        TableName: env.TOTAL_TABLE,
                        Key: { name: `${modelName}` },
                        UpdateExpression: `ADD val :plusOne`,
                        ExpressionAttributeValues: { ':plusOne': 1 },
                        ReturnValues: 'UPDATED_NEW',
                    };
                    const result = await dynamoDb.update(params).promise();
                    logger.info('Counter updated', result);
                } catch (error) {
                    throw new Error(`Errors in incrementing count: ${error}`);
                }
            } else if (record.eventName === "MODIFY") {
                // business logic to process updated records
                const newImage = record.dynamodb!.NewImage!;
                const oldImage = record.dynamodb!.OldImage!;
                const modelName = newImage.__typename.S;
                logger.info(`New ${modelName}, Image`, newImage);
                logger.info(`Old ${modelName}, Image`, oldImage);
                const { errors } = await client.models.Action.create({
                    type: "Update",
                    typeIndex: "Update",
                    description: `Updated ${modelName} - (auto-log)`,
                    userId: newImage.lastActivityBy.S,
                    modelName: modelName,
                    refId: newImage.id.S,
                    before: JSON.stringify(oldImage),
                    after: JSON.stringify(newImage)
                });
                logger.ifErrorThrow('Failed to create update action', errors);

            }
        } catch (error) {
            logger.error('Errors in creating action', error);
            const newImage = record.dynamodb!.NewImage!;
            fail.push({ itemIdentifier: newImage.id.S! });
        }
    }
    logger.info(`Successfully processed ${event.Records.length} records.`);

    return {
        batchItemFailures: [],
    };
};