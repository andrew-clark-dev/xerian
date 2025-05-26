import type { DynamoDBStreamHandler } from "aws-lambda";
import { logger } from "@backend/services/logger";
import { v4 as uuid4 } from "uuid";
import { DynamoService } from "@backend/services/dynamodb-service";

const TABLE_NAME = process.env.ACTION_TABLE;
const dynamoService = new DynamoService(TABLE_NAME!);

export const handler: DynamoDBStreamHandler = async (event) => {
    logger.info('DynamoDBStreamEvent', event);

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
                    id: uuid4(),
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
                    id: uuid4(),
                    type: "Update",
                    typeIndex: "Update",
                    description: `Updated ${modelName} - (auto-log)`,
                    userId: newImage.lastActivityBy.S,
                    modelName: modelName,
                    refId: newImage.id.S,
                    before: JSON.stringify(oldImage),
                    after: JSON.stringify(newImage)
                });

            }
        } catch (error) {
            const newImage = record.dynamodb!.NewImage!;
            logger.error(`Errors in creating action for ${record.eventName} ${newImage.__typename.S}, id: ${newImage.id.S} `, (error as Error).message);
        }
    }
    logger.info(`Successfully processed ${event.Records.length} records.`);

};