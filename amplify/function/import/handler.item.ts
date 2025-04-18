import { itemServices } from '@server/item-services';
import { SQSEvent, SQSHandler } from 'aws-lambda';
import { logger } from "@server/logger";

export const handler: SQSHandler = async (event: SQSEvent) => {
  logger.info('SQSEvent', event);
  for (const record of event.Records) {
    const body = record.body;
    console.log('Processing SQS message:');

    try {
      logger.info('body', body);
      const data = JSON.parse(body);
      console.log('Parsed data:', data);
      await itemServices.importItem(data);
    } catch (err) {
      console.error('Error parsing message body as JSON:', err);
    }
  }

  return;
};