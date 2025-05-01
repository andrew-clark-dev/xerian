import type { DynamoDBBatchItemFailure, DynamoDBStreamHandler } from "aws-lambda";
import { logger } from "@backend/services/logger";
import { DynamoService } from "@backend/services/dynamodb-service";

const TABLE_NAME = process.env.ACTION_TABLE;
const dynamoService = new DynamoService(TABLE_NAME!);

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
                await dynamoService.write({
                    __typename: 'Action',
                    type: "Create",
                    typeIndex: "Create",
                    description: `Created ${modelName} - (auto-log)`,
                    userId: newImage.lastActivityBy.S,
                    modelName: modelName,
                    refId: newImage.id.S,
                    after: JSON.stringify(newImage)
                });

            } else if (record.eventName === "MODIFY") {
                // business logic to process updated records
                const newImage = record.dynamodb!.NewImage!;
                const oldImage = record.dynamodb!.OldImage!;
                const modelName = newImage.__typename.S;
                logger.info(`New ${modelName}, Image`, newImage);
                logger.info(`Old ${modelName}, Image`, oldImage);
                await dynamoService.write({
                    __typename: 'Action',
                    type: "Create",
                    typeIndex: "Create",
                    description: `Created ${modelName} - (auto-log)`,
                    userId: newImage.lastActivityBy.S,
                    modelName: modelName,
                    refId: newImage.id.S,
                    before: JSON.stringify(oldImage),
                    after: JSON.stringify(newImage)
                });

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