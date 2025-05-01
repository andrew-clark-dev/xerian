import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, QueryCommand, UpdateCommand } from '@aws-sdk/lib-dynamodb';
import { logger } from "@backend/services/logger";
import { itemServices } from '@backend/services/item-services';
import { ExternalItem } from '@backend/services/http-client-types';

const client = DynamoDBDocumentClient.from(new DynamoDBClient({}));

const TABLE_NAME = process.env.IMPORTDATA_TABLE;
const STATUS_INDEX = 'importDataByStatusAndCreatedAt'; // Standard Amplify naming convention

export const handler = async () => {
  let added = 0;
  let errors = 0;

  const pendingItems = await client.send(
    new QueryCommand({
      TableName: TABLE_NAME,
      IndexName: STATUS_INDEX,
      KeyConditionExpression: '#status = :pending',
      ExpressionAttributeNames: {
        '#status': 'status',
      },
      ExpressionAttributeValues: {
        ':pending': 'Pending',
      },
      ScanIndexForward: true, // Set to false for descending order
    })
  );

  if (!pendingItems.Items || pendingItems.Items.length === 0) {
    logger.info('No pending items found.');
    return {
      "finished": true,
      "itemsProcessed": 0,
      "errors": 0,
      "total": 0,
    }
  }

  logger.info(`Found ${pendingItems.Items.length} items to process.`);

  for (const item of pendingItems.Items) {
    try {
      logger.info(`Processing import data record.`, item.data);
      const data = JSON.parse(item.data) as ExternalItem;
      logger.info(`Processing External item.`, data);

      await itemServices.importItem(data);

      await client.send(
        new UpdateCommand({
          TableName: TABLE_NAME,
          Key: {
            id: item.id,
          },
          UpdateExpression: 'SET #status = :completed',
          ExpressionAttributeNames: {
            '#status': 'status',
          },
          ExpressionAttributeValues: {
            ':completed': 'Completed',
          },
        })
      );

      logger.info(`Marked item ${item.id} as Completed.`);
      added++;

    } catch (error) {
      logger.error(`Error processing item ${item.id}:`, (error as Error).message);
      errors++;
      await client.send(
        new UpdateCommand({
          TableName: TABLE_NAME,
          Key: {
            id: item.id,
          },
          UpdateExpression: 'SET #status = :failed',
          ExpressionAttributeNames: {
            '#status': 'status',
          },
          ExpressionAttributeValues: {
            ':failed': 'Failed',
          },
        })
      );
    }
  }
  logger.success(`Successfully processed ${added} items, with ${errors} errors`);
  return {
    "finished": false,
    "itemsProcessed": added,
    "errors": errors,
    "total": pendingItems.Items.length,
  }
};
