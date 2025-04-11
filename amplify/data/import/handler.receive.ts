import { S3Handler } from "aws-lambda";
import { logger } from "@server/logger";
import * as readline from "readline";
import * as stream from "stream";
import { s3body, uploadChunk, archiveFile, fromEvent } from "@server/file.utils";


// Read `MAX_LINES` and `OUTPUT_DIR` from environment variables
const MAX_LINES = parseInt(process.env.MAX_LINES!, 10);

/**
 * Lambda Handler Function
 */
export const handler: S3Handler = async (event): Promise<void> => {
    logger.info(`S3 event: ${JSON.stringify(event)}`);
    logger.info('Lambda Environment Variables:', { environmentVariables: process.env });

    const { bucket, key } = fromEvent(event)

    try {
        logger.start(`Processing file: s3://${bucket}/${key}`);

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
                await uploadChunk(bucket, headers, batchLines, ++fileCounter, key);
                batchLines = [];
                lineCounter = 0;
            }
        }

        // Upload remaining lines if any
        if (batchLines.length > 0) {
            await uploadChunk(bucket, headers!, batchLines, ++fileCounter, key);
        }

        logger.success(`Successfully split file ${key}, into ${fileCounter} parts.`);

        // Move the file to the archive folder 
        await archiveFile(bucket, key);

    } catch (error) {
        logger.failure(`Error processing file ${key}`, error);
        throw error; // Rethrow the error to ensure Lambda knows it failed
    }
};

