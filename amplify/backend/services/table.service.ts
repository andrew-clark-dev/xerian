import { AttributeMap } from "aws-sdk/clients/dynamodb";
import { logger } from "@backend/services/logger";

import * as AWS from 'aws-sdk';

const docClient = new AWS.DynamoDB.DocumentClient();

export const truncateTable = async (name: string, index: string[]) => {
    logger.info(`Truncate: ${name}`);

    const tableName = process.env[name]!;

    const scanParams: AWS.DynamoDB.DocumentClient.ScanInput = { TableName: tableName };
    let itemsToDelete: AWS.DynamoDB.DocumentClient.ItemList = [];

    try {
        // Scan the table and handle pagination
        logger.info(`ScanTable  ${scanParams.TableName} with ${index}`);
        do {
            try {
                const scanResult = await docClient.scan(scanParams).promise();
                logger.info(`Deleting ${scanResult.Count || "No"} records from ${tableName}`);
                if (scanResult && scanResult.Items) {
                    itemsToDelete = itemsToDelete.concat(scanResult.Items);
                }
                // Set the ExclusiveStartKey for the next scan if there are more items
                scanParams.ExclusiveStartKey = scanResult?.LastEvaluatedKey;
            } catch (error) {
                logger.error(`Error scanning table: ${tableName}, error: ${error}`);
                throw error;
            }

        } while (scanParams.ExclusiveStartKey);

        const itemChunks = chunkArray(itemsToDelete, 25);

        // For every chunk of 25 items, make one BatchWrite request.
        for (const chunk of itemChunks) {
            const deleteRequests = chunk.map((item: AttributeMap) => ({
                DeleteRequest: {
                    Key: Object.fromEntries(index.map(key => [key, item[key]]),),
                },
            }));

            console.info(`Delete Requests: ${JSON.stringify(deleteRequests)}`);

            await docClient.batchWrite({ RequestItems: { [tableName]: deleteRequests } }).promise();
        }
        logger.info(`Table ${tableName} truncated successfully, ${itemsToDelete.length} items deleted`);
    } catch (error) {
        logger.error(`Error truncating table: ${tableName}, error ${error}`);
        throw error;
    }

};

/**
 *
 * @param {Array} arr
 * @param {number} stride
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function* chunkArray(arr: any, stride = 1) {
    for (let i = 0; i < arr.length; i += stride) {
        yield arr.slice(i, Math.min(i + stride, arr.length));
    }
}