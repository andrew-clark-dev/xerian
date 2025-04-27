import { EventBridgeEvent, EventBridgeHandler } from 'aws-lambda';

import { v4 as uuid4 } from 'uuid';


import { S3Client, GetObjectCommand, CopyObjectCommand, PutObjectCommand } from '@aws-sdk/client-s3';
import { DynamoService } from '../../services/dynamodb-service';
import { logger } from '../../services/logger';
import { fetchPagedItems } from '../../services/http-client-service';


const s3 = new S3Client({});


type DetailType = 'Scheduled Event';

const tableName = process.env.IMPORTDATA_TABLE;
const dynamoService = new DynamoService(tableName!);

export const handler: EventBridgeHandler<DetailType, unknown, void> = async (
    event: EventBridgeEvent<DetailType, unknown>
) => {
    logger.info('EventBridgeEvent', event);

    // Get the object from the event 
    const bucket = process.env.DRIVE_BUCKET_NAME!
    const key = 'import/sync-next.json'
    const params = {
        Bucket: bucket,
        Key: key,
    };

    try {
        logger.start(`Processing file: s3://${bucket}/${key}`, event);

        // Get the file contents from S3
        const { Body } = await s3.send(new GetObjectCommand(params));
        const content = await Body?.transformToString();

        const jsonContent = JSON.parse(content ?? '');
        logger.info('jsonContent', jsonContent);

        // Extract 'to' and 'from' attributes
        const { from, to } = jsonContent;
        logger.info('from to ', { from, to });

        // Parse 'to' and 'from' to Date objects
        const fromDate = new Date(from);
        const toDate = new Date(to);
        logger.info('fromDate toDate ', { fromDate, toDate });
        if (isNaN(fromDate.getTime()) || isNaN(toDate.getTime())) {
            logger.error('Invalid date format', { from, to });
            throw new Error('Invalid date format');
        }

        let cursor: string | null | undefined = null;
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
                    __typename: 'ImportData',
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

        // copy the imported range file
        const newKey = `import/sync-${toDate.toISOString()}.json`;
        await s3.send(new CopyObjectCommand({
            Bucket: bucket,
            CopySource: `${bucket}/${key}`, // format: "bucket/key"
            Key: newKey,
        }));

        // Create next import range file
        toDate.setMonth(toDate.getMonth() + 1)
        const nextImportRange = {
            from: to,
            to: toDate.toISOString(), // Add one day
        }

        await s3.send(new PutObjectCommand({
            Bucket: bucket,
            Key: key,
            Body: JSON.stringify(nextImportRange),
        }));

        // Log the extracted and parsed dates
        logger.success(`Successfully processed ${added} items, from ${from}. to ${to}`);

    } catch (error) {
        logger.failure(`Error processing s3://${bucket}/${key}`, error);
        throw error;
    }

};
