import { logger } from '@backend/services/logger';
import { fetchPagedItems } from '@backend/services//http-client-service';
import { DynamoService } from '@backend/services//dynamodb-service';

interface FetchDataEvent {
  from: string;
  to: string;
}

const TABLE_NAME = process.env.IMPORTDATA_TABLE;
const dynamoService = new DynamoService(TABLE_NAME!);

export const handler = async (event: FetchDataEvent) => {
  logger.info('Event', event);
  // Parse 'to' and 'from' to Date objects
  const fromDate = new Date(event.from)
  const toDate = new Date(event.to)

  const from = fromDate.toISOString();
  const to = toDate.toISOString();
  logger.info(`from: ${from} to: ${to}`);

  try {

    let cursor = null;
    let hasMorePages = true;
    let added = 0;
    let errors = 0;

    while (hasMorePages) {
      const response = await fetchPagedItems({
        cursor: cursor,
        createdGte: from,
        createdLt: to,
      });
      logger.info('response', response);

      // Assuming the API returns { data, hasNextPage }
      const { data, next_cursor } = response;
      cursor = next_cursor;
      hasMorePages = cursor ? true : false;

      for (const item of data) {
        try {
          const importData = {
            __typename: 'ImportData',
            id: item.sku,
            createdAt: new Date().toISOString(),
            type: 'Item',
            data: JSON.stringify(item),
            status: 'Pending',
          };

          await dynamoService.write(importData);
          added++;
        } catch (error) {
          logger.error('Error writing item to DynamoDB', error);
          errors++;
        }
      }
    }

    // Log the number of items processed
    logger.success(`Successfully processed ${added} items, from ${from} to ${to}, with ${errors} errors`);

    // Return whether there are more pages, and the cursor for pagination
    toDate.setMonth(toDate.getMonth() + 1)
    return {
      more: (toDate < new Date()), // Determine if there are more pages
      from: to,                           // Set new 'from' date
      to: toDate.toISOString(),           // Set the next 'to' date
    };
  } catch (error) {
    logger.failure(`Error processing items, from ${from} to ${to}`, error);
    throw error;
  }
};
