import type { DynamoDBStreamHandler } from "aws-lambda";
import { logger } from "@backend/services/logger";
import { DynamoService } from "@backend/services/dynamodb-service";

const TABLE_NAME = process.env.ITEMSTATS_TABLE;
const dynamoService = new DynamoService(TABLE_NAME!);

export const handler: DynamoDBStreamHandler = async (event) => {
    logger.info('DynamoDBStreamEvent', event);

    for (const record of event.Records) {
        try {

            if (record.eventName === "INSERT" || record.eventName === "MODIFY") {
                // business logic to process new records
                const newImage = record.dynamodb!.NewImage!;
                const isoDateTime = newImage.createdAt.S!;
                const day = isoDateTime.split("T")[0];
                const month = isoDateTime.substring(0, 7);
                await dynamoService.upsert(
                    {
                        itemSku: newImage.sku.S!,
                        createdAt: newImage.createdAt.S!,
                    },
                    {
                        __typename: 'ItemStats',
                        createdAt: newImage.createdAt.S,
                        day: day,
                        month: month,
                        itemSku: newImage.sku.S!,
                        createdBy: newImage.lastActivityBy.S,
                        category: newImage.category.S,
                        price: parseInt(newImage.price.N ?? '0')
                    });
            }
        } catch (error) {
            const newImage = record.dynamodb!.NewImage!;
            logger.error(`Errors writing stats for ${record.eventName} ${newImage.__typename.S}, id: ${newImage.id.S} `, (error as Error).message);
        }
    }
    logger.info(`Successfully processed ${event.Records.length} records.`);

};