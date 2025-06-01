import { S3Client, GetObjectCommand } from '@aws-sdk/client-s3';
import { Logger } from '@aws-lambda-powertools/logger';
import { itemServices } from '../../backend/services/item-services';

const s3 = new S3Client({});
const logger = new Logger();

export const handler = async (event: { key: string }) => {
  logger.info('Processing file from S3', { event });

  const bucket = process.env.BUCKET_NAME!;

  const response = await s3.send(new GetObjectCommand({
    Bucket: bucket,
    Key: event.key
  }));

  if (!response.Body) {
    // Handle the case where the body is undefined, e.g., throw an error
    throw new Error("S3 object body is undefined.");
  }

  const raw = await response.Body.transformToString();
  const records = JSON.parse(raw);

  const errors = [];
  for (const item of records) {
    try {
      await itemServices.importItem(item);
    } catch (err) {
      errors.push({ item, error: err instanceof Error ? err.message : String(err) });
    }
  }

  const { PutObjectCommand, DeleteObjectCommand, CopyObjectCommand } = await import('@aws-sdk/client-s3');
  const s3Key = event.key;
  if (errors.length > 0) {
    // Write errors as JSON to error/ folder
    const errorKey = s3Key.replace(/^.*[\\/]/, 'error/'); // replace path with error/
    await s3.send(new PutObjectCommand({
      Bucket: bucket,
      Key: errorKey,
      Body: JSON.stringify(errors, null, 2),
      ContentType: 'application/json',
    }));
    logger.warn('Some items failed to import. Errors written to S3.', { errorKey, count: errors.length });
  } else {
    // Copy file to done/ folder
    const doneKey = s3Key.replace(/^.*[\\/]/, 'done/');
    await s3.send(new CopyObjectCommand({
      Bucket: bucket,
      CopySource: `${bucket}/${s3Key}`,
      Key: doneKey,
    }));
    await s3.send(new DeleteObjectCommand({
      Bucket: bucket,
      Key: s3Key,
    }));
    logger.info('File processed successfully and copied to done folder.', { doneKey });
  }
};
