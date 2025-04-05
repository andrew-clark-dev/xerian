import { S3Handler } from "aws-lambda";
import { logger } from "@server/logger";
import { S3 } from "@aws-sdk/client-s3";
import * as readline from "readline";
import * as stream from "stream";
import { s3body, uploadChunk, archiveFile } from "@server/file.utils";

const s3 = new S3({ region: process.env.AWS_REGION });

// Read `MAX_LINES` and `OUTPUT_DIR` from environment variables
const MAX_LINES = parseInt(process.env.MAX_LINES!, 10);

/**
 * Lambda Handler Function
 */
export const handler: S3Handler = async (event): Promise<void> => {
    logger.info(`S3 event: ${JSON.stringify(event)}`);
    logger.info('Lambda Environment Variables:', { environmentVariables: process.env });

    const bucketName = event.Records[0].s3.bucket.name;
    const objectKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));

    try {
        logger.info(`Processing file: s3://${bucketName}/${objectKey}`);

        // Get object stream
        const body = await s3body(event);

        const rl = readline.createInterface({
            input: body as stream.Readable,
            crlfDelay: Infinity,
        });

        let fileCounter = 0;
        let lineCounter = 0;
        let headers: string | null = null;
        let batchLines: string[] = [];

        for await (const line of rl) {
            if (!headers) {
                headers = line; // Store header row
                continue;
            }

            batchLines.push(line);
            lineCounter++;

            if (lineCounter >= MAX_LINES) {
                await uploadChunk(bucketName, headers, batchLines, ++fileCounter, objectKey);
                batchLines = [];
                lineCounter = 0;
            }
        }

        // Upload remaining lines if any
        if (batchLines.length > 0) {
            await uploadChunk(bucketName, headers!, batchLines, ++fileCounter, objectKey);
        }

        logger.info(`Successfully split file into ${fileCounter} parts.`);

        // Move the file to the archive folder 
        await archiveFile(bucketName, objectKey);

    } catch (error) {
        logger.error(`Error processing file: ${error}`);
        throw error; // Rethrow the error to ensure Lambda knows it failed
    }
};

