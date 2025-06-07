import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { v4 as uuidv4 } from 'uuid';
import { Logger } from '@aws-lambda-powertools/logger';
import { fetchPagedItems } from '../../src/http-client-service';

const s3 = new S3Client({});
const logger = new Logger();

interface FetchEvent {
  cursor?: string;
}

interface FetchResponse {
  cursor: string | null;
  key: string;
}

export const handler = async (event: FetchEvent): Promise<FetchResponse> => {
  logger.info('Received event', { event });

  const cursor = event.cursor ?? null;

  const result = await fetchPagedItems({ cursor });
  const data = result.data;
  const nextCursor = result.next_cursor;

  const key = `import/fetched/item/item-list-${uuidv4()}.json`;

  await s3.send(new PutObjectCommand({
    Bucket: process.env.BUCKET_NAME!,
    Key: key,
    Body: JSON.stringify(data),
    ContentType: 'application/json',
  }));

  logger.info('Written file to S3', { key });

  return {
    cursor: nextCursor,
    key,
  };
};