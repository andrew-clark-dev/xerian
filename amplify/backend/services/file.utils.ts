import { S3Client, GetObjectCommand, GetObjectCommandOutput } from "@aws-sdk/client-s3";

import { logger } from "@backend/services/logger";

import { S3Event } from "aws-lambda";
import { Readable } from "stream";


const s3 = new S3Client({ region: process.env.AWS_REGION });


// Function to upload a chunk to S3
// export async function uploadChunk(bucket: string, headers: string, lines: string[], partNumber: number, key: string) {
//     const originalFileName = key.split("/").pop()!;
//     // Remove file extension (e.g., ".csv") to avoid duplication in the name
//     const baseName = originalFileName.replace(/\.[^/.]+$/, "");
//     const newFileKey = `${PROCESSING_DIR}${baseName}-part-${partNumber}.csv`;

//     const csvData = [headers, ...lines].join("\n");

//     // Send the command using s3Client
//     await s3.send(new PutObjectCommand({
//         Bucket: bucket,
//         Key: newFileKey,
//         Body: csvData,
//         ContentType: 'text/csv'
//     }));

//     logger.info(`Uploaded: s3://${bucket}/${newFileKey}`);
// }

// export async function archiveFile(bucket: string, originalKey: string, errorCount = 0) {
//     try {
//         const destinationKey = errorCount == 0 ?
//             `${ARCHIVE_DIR}${originalKey.split('/').pop()}` :
//             `${ERROR_DIR}${originalKey.split('/').pop()}.${new Date().toISOString()}-errors-${errorCount}`;
//         // Copy the file to the new location
//         await s3.send(new CopyObjectCommand({
//             Bucket: bucket,
//             CopySource: `${bucket}/${originalKey}`,
//             Key: destinationKey,
//         }));

//         // Delete the original file
//         await s3.send(new DeleteObjectCommand({
//             Bucket: bucket,
//             Key: originalKey,
//         }));

//         logger.info(`Moved file from s3://${bucket}/${originalKey} to s3://${bucket}/${destinationKey}`);
//     } catch (error) {
//         logger.error('Error archiving file: ', error);
//         throw error; // Rethrow the error to ensure Lambda knows it failed
//     }
// }

// export async function writeErrorFile(bucket: string, originalKey: string, row: unknown, id: string, error: unknown) {
//     try {
//         const destinationKey = `${ERROR_DIR}${originalKey.split('/').pop()}-${new Date().toISOString()}-error.log`;
//         const message = `Error processing row: ${JSON.stringify(row)} - with profile id: ${id}`;

//         const body = (error instanceof Error) ? `${message}\n\nMessage:${error.message}\n\nStack:\n${error.stack}` : `${message}\n\n${JSON.stringify(error)}`;

//         // Send the command using s3Client
//         await s3.send(new PutObjectCommand({
//             Bucket: bucket,
//             Key: destinationKey,
//             Body: body,
//             ContentType: 'text/plain'
//         }));

//         logger.info(`Created error log s3://${bucket}/${destinationKey}`);
//     } catch (error) {
//         logger.error('Error writing errot file: ', error);
//     }
//     throw error; // Rethrow the error to ensure Lambda knows it failed

// }

export function fromEvent(event: S3Event): { bucket: string; key: string } {
    if (!event.Records || event.Records.length === 0) {
        throw new Error("No records found in the S3 event.");
    }

    const bucket = event.Records[0].s3.bucket.name;
    const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));
    return { bucket, key };
};

export function s3params(event: S3Event): { Bucket: string; Key: string } {
    try {
        if (!event.Records || event.Records.length === 0) {
            throw new Error("No records found in the S3 event.");
        }

        const Bucket = event.Records[0].s3.bucket.name;
        const Key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));
        return { Bucket, Key };
    } catch (error) {
        logger.error('Error getting S3 params: ', error);
        throw error;
    }
};

type BodyType = Buffer | Uint8Array | Blob | string | ReadableStream | Readable;

export async function s3body(event: S3Event): Promise<BodyType> {

    const params = s3params(event);
    const s3Object: GetObjectCommandOutput = await s3.send(new GetObjectCommand(params));
    const body = s3Object.Body as BodyType;

    return body;

};
