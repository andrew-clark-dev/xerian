import { S3Handler } from "aws-lambda";
import { CopyObjectCommand, DeleteObjectCommand, PutObjectCommand, S3 } from "@aws-sdk/client-s3";
import * as readline from "readline";
import * as stream from "stream";
import { Logger } from "@aws-lambda-powertools/logger";

const s3 = new S3({ region: process.env.AWS_REGION });
const logger = new Logger({ serviceName: "import-recieve-function" });

// Read `MAX_LINES` and `OUTPUT_DIR` from environment variables
const MAX_LINES = parseInt(process.env.MAX_LINES!, 10);
const PROCESSING_DIR = process.env.PROCESSING_DIR!;
const ARCHIVE_DIR = process.env.ARCHIVE_DIR!;
const ERROR_DIR = process.env.ERROR_DIR!;
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
        const object = await s3.getObject({ Bucket: bucketName, Key: objectKey });
        if (!object.Body) {
            throw new Error("Empty file or unable to read object body.");
        }

        const rl = readline.createInterface({
            input: object.Body as stream.Readable,
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

// Function to upload a chunk to S3
async function uploadChunk(bucket: string, headers: string, lines: string[], partNumber: number, key: string) {
    const originalFileName = key.split("/").pop()!;
    // Remove file extension (e.g., ".csv") to avoid duplication in the name
    const baseName = originalFileName.replace(/\.[^/.]+$/, "");
    const newFileKey = `${PROCESSING_DIR}${baseName}-part-${partNumber}.csv`;

    const csvData = [headers, ...lines].join("\n");

    // Send the command using s3Client
    await s3.send(new PutObjectCommand({
        Bucket: bucket,
        Key: newFileKey,
        Body: csvData,
        ContentType: 'text/csv'
    }));

    logger.info(`Uploaded: s3://${bucket}/${newFileKey}`);
}

export async function archiveFile(bucket: string, originalKey: string) {
    try {
        const destinationKey = `${ARCHIVE_DIR}${originalKey.split('/').pop()}`;
        // Copy the file to the new location
        await s3.send(new CopyObjectCommand({
            Bucket: bucket,
            CopySource: `${bucket}/${originalKey}`,
            Key: destinationKey,
        }));

        // Delete the original file
        await s3.send(new DeleteObjectCommand({
            Bucket: bucket,
            Key: originalKey,
        }));

        logger.info(`Moved file from s3://${bucket}/${originalKey} to s3://${bucket}/${destinationKey}`);
    } catch (error) {
        logger.error(`Error moving file: ${error}`);
        throw error; // Rethrow the error to ensure Lambda knows it failed
    }
}

export async function writeErrorFile(bucket: string, originalKey: string, row: unknown, id: string, error: unknown) {
    try {
        const destinationKey = `${ERROR_DIR}${originalKey.split('/').pop()}-${new Date().toISOString()}-error.log`;
        const message = `Error processing row: ${JSON.stringify(row)} - with profile id: ${id}`;

        const body = (error instanceof Error) ? `${message}\n\nMessage:${error.message}\n\nStack:\n${error.stack}` : `${message}\n\n${JSON.stringify(error)}`;

        // Send the command using s3Client
        await s3.send(new PutObjectCommand({
            Bucket: bucket,
            Key: destinationKey,
            Body: body,
            ContentType: 'text/plain'
        }));

        logger.info(`Created error log s3://${bucket}/${destinationKey}`);
    } catch (error) {
        logger.error(`Error moving file: ${error}`);
        throw error; // Rethrow the error to ensure Lambda knows it failed
    }

}