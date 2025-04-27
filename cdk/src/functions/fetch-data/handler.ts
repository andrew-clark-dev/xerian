
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
  try {
    // Parse 'to' and 'from' to Date objects
    // Extract 'to' and 'from' attributes
    const { from, to } = event;
    const fromDate = new Date(from);
    const toDate = new Date(to);
    logger.info('fromDate toDate ', { fromDate, toDate });
    if (isNaN(fromDate.getTime()) || isNaN(toDate.getTime())) {
      logger.error('Invalid date format', { from, to });
      throw new Error('Invalid date format');
    }
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
    // Log the extracted and parsed dates
    logger.success(`Successfully processed ${added} items, from ${from}. to ${to}`);

    // Return next cursor and whether more pages exist
    toDate.setMonth(toDate.getMonth() + 1) // Increment the month for the next range
    return {
      from: to,
      to: toDate.toISOString(),
    };

  } catch (error) {
    console.error('Error fetching data:', error);
    throw new Error('Error fetching data');
  }
};
