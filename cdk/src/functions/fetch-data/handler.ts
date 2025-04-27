import { logger } from '../../services/logger';
import { fetchPagedItems } from '../../services/http-client-service';
import { DynamoService } from '../../services/dynamodb-service';
import { v4 as uuid4 } from 'uuid';

interface FetchDataEvent {
  from: string;
  to: string;
}

const tableName = process.env.DYNAMODB_TABLE;
const dynamoService = new DynamoService(tableName!);

export const handler = async (event: FetchDataEvent) => {
  logger.info('Event', event);
  // Parse 'to' and 'from' to Date objects
  const { from, to } = event;
  logger.info(`from: ${from} to: ${to}`);

  const toDate = new Date(to);

  try {

    let cursor = null;
    let hasMorePages = true;
    let added = 0;

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

        const importData = {
          id: uuid4(),
          createdAt: new Date().toISOString(),
          type: 'Item',
          data: JSON.stringify(item),
          imported: false,
        };

        await dynamoService.write(importData);
        added++;
      }
    }

    // Log the number of items processed
    logger.success(`Successfully processed ${added} items, from ${from} to ${to}`);

    // Return whether there are more pages, and the cursor for pagination
    toDate.setMonth(toDate.getMonth() + 1)
    return {
      hasMorePages: (toDate < new Date()), // Determine if there are more pages
      from: to,                           // Set new 'from' date
      to: toDate.toISOString(),           // Set the next 'to' date
    };
  } catch (error) {
    logger.failure(`Error processing items, from ${from} to ${to}`, error);
    throw error;
  }
};
