import type { DynamoDBStreamHandler } from "aws-lambda";
import { logger } from "@backend/services/logger";
import { DynamoService } from "@backend/services/dynamodb-service";

const TABLE_NAME = process.env.SALESTATS_TABLE;
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
                        saleNumber: newImage.number.S!,
                        createdAt: newImage.createdAt.S!,
                    },
                    {
                        __typename: 'SaleStats',
                        createdAt: newImage.createdAt.S,
                        day: day,
                        month: month,
                        saleNumber: newImage.number.S!,
                        // eslint-disable-next-line @typescript-eslint/no-explicit-any
                        items: Object.fromEntries(newImage.items.L!.map((t: any) => [t.M.sku.S, t.M.value.S])),
                        createdBy: newImage.lastActivityBy.S,
                        total: parseInt(newImage.total.N ?? '0')
                    });
            }
        } catch (error) {
            const newImage = record.dynamodb!.NewImage!;
            logger.error(`Errors writing stats for ${record.eventName} ${newImage.__typename.S}, id: ${newImage.id.S} `, (error as Error).message);
        }
    }
    logger.info(`Successfully processed ${event.Records.length} records.`);

};