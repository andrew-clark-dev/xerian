import { DynamoDBStreamHandler, DynamoDBStreamEvent, DynamoDBBatchItemFailure } from 'aws-lambda';
import { ExternalItem } from '@cdk/services/http-client-types';
import { logger } from '@cdk/services/logger';
import { itemServices } from '@cdk/services/item-services';


export const handler: DynamoDBStreamHandler = async (event: DynamoDBStreamEvent) => {
  logger.info('DynamoDBStreamEvent', event);
  const fail: DynamoDBBatchItemFailure[] = [];

  for (const record of event.Records) {
    logger.info(`Processing Event Type: ${record.eventName} - record: ${JSON.stringify(record)}`);

    try {
      if (record.eventName === "INSERT") {
        // business logic to process new records
        const newImage = record.dynamodb?.NewImage;

        if (!newImage) {
          logger.error('No new image found in the record');
          continue;
        } else {
          const data = JSON.parse(newImage.data.S || '{}') as ExternalItem;
          console.log('Parsed data:', data);
          await itemServices.importItem(data);
        }
      }
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Unknown error';
      logger.failure(`Errors in importing item - ${message} `, record);
      const newImage = record.dynamodb!.NewImage!;
      fail.push({ itemIdentifier: newImage.id.S! });
    }
  }


  return {
    batchItemFailures: fail,
  };
};