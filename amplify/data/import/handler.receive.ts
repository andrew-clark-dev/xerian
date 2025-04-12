import { fetchPagedItems } from '@server/consigncloud/http-client-service';
import { S3Event, S3Handler } from 'aws-lambda';
import { uploadData } from "aws-amplify/storage";
import { logger } from "@server/logger";
import { archiveFile, fromEvent, s3body } from "@server/file.utils";



export const handler: S3Handler = async (event: S3Event) => {
    logger.info('S3Event', event);
    const { bucket, key } = fromEvent(event)
    const PROCESSING_DIR = process.env.PROCESSING_DIR;
    try {
        logger.start(`Processing file: s3://${bucket}/${key}`, event);

        // Get the file contents from S3
        const body = await s3body(event);

        const jsonContent = JSON.parse(body?.toString('utf-8') ?? '');

        // Extract 'to' and 'from' attributes
        const { from, to } = jsonContent;

        // Parse 'to' and 'from' to Date objects
        const fromDate = new Date(from);
        const toDate = new Date(to);

        if (isNaN(fromDate.getTime()) || isNaN(toDate.getTime())) {
            logger.error('Invalid date format', { to, from });
            throw new Error('Invalid date format');
        }

        // Format the dates to 'YYYYMMDD'
        const fromDateString = fromDate.toISOString().split('T')[0].replace(/-/g, ''); // '20250411'    
        const toDateString = toDate.toISOString().split('T')[0].replace(/-/g, ''); // '20250412'

        // Construct the S3 filename
        const s3FileName = `${PROCESSING_DIR}Items-${fromDateString}-${toDateString}.txt`;

        let cursor = null;
        let hasMorePages = true;
        let fileContent: string = '';
        let added = 0;


        while (hasMorePages) {
            const response = await fetchPagedItems({
                cursor: cursor,
                createdGte: from,
                createdLt: to,
            });

            // Assuming the API returns { data, hasNextPage }
            const { data, next_cursor } = response;
            cursor = next_cursor;
            hasMorePages = cursor ? true : false;
            data.forEach((item) => {
                fileContent += `${JSON.stringify(item)}\n`;
                added++
            });
        }

        // Use Amplify Storage to upload the content to S3
        await uploadData({ data: fileContent, path: s3FileName });

        // Log the extracted and parsed dates
        logger.success(`Successfully processed s3://${bucket}/${key}, ${added} added, file uploaded to s3://${bucket}/${s3FileName}`);

        // Archive the original file
        await archiveFile(bucket, key);

        // You can perform any additional logic here (e.g., store in a database, call an API, etc.)

    } catch (error) {
        logger.failure(`Error processing s3://${bucket}/${key}`, error);
    }

};
