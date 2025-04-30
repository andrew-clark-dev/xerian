import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, QueryCommand, UpdateCommand } from '@aws-sdk/lib-dynamodb';
import { logger } from "@backend/services/logger";
import { itemServices } from '@backend/services/item-services';

const client = DynamoDBDocumentClient.from(new DynamoDBClient({}));

const TABLE_NAME = process.env.IMPORTDATA_TABLE;
const STATUS_INDEX = 'importDataByStatus'; // Standard Amplify naming convention



export const handler = async () => {
  let more = true;
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
    })
  );

  if (!pendingItems.Items || pendingItems.Items.length === 0) {
    logger.info('No pending items found.');
    return more = false;
  }

  logger.info(`Found ${pendingItems.Items.length} items to process.`);

  for (const item of pendingItems.Items) {
    try {
      await itemServices.importItem(item.data);

      await client.send(
        new UpdateCommand({
          TableName: TABLE_NAME,
          Key: {
            id: item.id,
            createdAt: item.createdAt,
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
      logger.error(`Error processing item ${item.id}:`, error);
      errors++;
      await client.send(
        new UpdateCommand({
          TableName: TABLE_NAME,
          Key: {
            id: item.id,
            createdAt: item.createdAt,
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
    logger.success(`Successfully processed ${added} items, with ${errors} errors`);
    return {
      "finished": more,
      "itemsProcessed": added,
      "errors": errors,
      "total": pendingItems.Items.length,
    }
  }
};

