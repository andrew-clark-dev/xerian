// import { S3Handler } from "aws-lambda";
// import { logger } from "@server/logger";
// import * as readline from "readline";
// import { uploadChunk, archiveFile, fromEvent, s3body } from "@server/file.utils";
// import { Readable } from "stream";

// // Read `MAX_LINES` and `OUTPUT_DIR` from environment variables
// const MAX_LINES = parseInt(process.env.MAX_LINES!, 10);

// /**
//  * Lambda Handler Function
//  */
// export const handler: S3Handler = async (event): Promise<void> => {
//     logger.info(`S3 event: ${JSON.stringify(event)}`);
//     logger.info('Lambda Environment Variables:', { environmentVariables: process.env });

//     const { bucket, key } = fromEvent(event)
//     const body = await s3body(event);

//     try {
//         logger.info(`Processing file: s3://${bucket}/${key}`);

//         const rl = readline.createInterface({
//             input: body as Readable,
//             crlfDelay: Infinity,
//         });

//         let fileCounter = 0;
//         let lineCounter = 0;
//         let headers: string | null = null;
//         let batchLines: string[] = [];

//         for await (const line of rl) {
//             if (!headers) {
//                 headers = line; // Store header row
//                 continue;
//             }

//             batchLines.push(line);
//             lineCounter++;

//             if (lineCounter >= MAX_LINES) {
//                 await uploadChunk(bucket, headers, batchLines, ++fileCounter, key);
//                 batchLines = [];
//                 lineCounter = 0;
//             }
//         }

//         // Upload remaining lines if any
//         if (batchLines.length > 0) {
//             await uploadChunk(bucket, headers!, batchLines, ++fileCounter, key);
//         }

//         logger.info(`Successfully split file into ${fileCounter} parts.`);

//         // Move the file to the archive folder 
//         await archiveFile(bucket, key);

//     } catch (error) {
//         logger.error(`Error processing file: ${error}`);
//         throw error; // Rethrow the error to ensure Lambda knows it failed
//     }
// };

