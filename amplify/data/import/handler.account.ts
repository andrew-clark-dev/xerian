import type { S3Handler } from "aws-lambda";
import { Schema } from "../resource";
import { generateClient } from "aws-amplify/data";
import { logger } from "@server/logger";
import { Amplify } from "aws-amplify";
import { getAmplifyDataClientConfig } from '@aws-amplify/backend/function/runtime';
import { env } from "../../../.amplify/generated/env/import-account-function";
import AWS from "aws-sdk";
import Papa from "papaparse";
import { archiveFile } from "@server/file.utils";

import { money, isMobileNumber, comunicationPreferences } from "@server/import.utils";
import { userService } from "@server/user.service";
import { IMPORT_SERVICE_USER_ID } from "../constants";

export type AccountStatus = Schema['Account']['type']['status'];
export type AccountKind = Schema['Account']['type']['kind'];

const { resourceConfig, libraryOptions } = await getAmplifyDataClientConfig(env);

Amplify.configure(resourceConfig, libraryOptions);

const client = generateClient<Schema>();

// Initialize AWS clients
const s3 = new AWS.S3();

/**
 * Lambda Handler Function
 */

export interface Header {
    'Number': string,
    'Created': string,
    'Created By': string,
    'Locations': string,
    'Deactivated': string,
    'Email': string,
    'Phone': string,
    'First Name': string,
    'Last Name': string,
    'Company': string,
    'Tags': string,
    'Balance': string,
    'Payable': string,
    'Default Split': string,
    'Terms': string,
    'Inventory Type': string,
    'Address Line 1': string,
    'Address Line 2': string,
    'City': string,
    'State': string,
    'Zip': string,
    'Number Of Sales': string,
    'Number Of Items': string,
    'Last Viewed': string,
    'Last Activity': string,
    'Last Item Entered': string,
    'Last Settlement': string,
    'Has Recurring Fees': string
}


/**
 * Lambda Handler Function
 */
export const handler: S3Handler = async (event): Promise<void> => {
    logger.info('S3Event', event);
    try {
        const bucket = event.Records[0].s3.bucket.name;
        const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));

        // Get the file from S3
        const s3Object = await s3.getObject({ Bucket: bucket, Key: key }).promise();
        if (!s3Object.Body) {
            throw new Error("File is empty or not accessible.");
        }

        // Parse CSV data
        const csvContent = s3Object.Body.toString("utf-8");
        const { data } = Papa.parse<Header>(csvContent, { header: true });

        // Insert data into DynamoDB
        for (const row of data) {
            const nickname = row['Created By']
            const profile = await userService.provisionUser(nickname);
            const account = await client.models.Account.get({ number: row['Number'] });
            if (account.data) {
                logger.info('Account already exists', account.data);
            } else {
                const newAccount = {
                    number: row['Number'],
                    addressLine1: row['Address Line 1'],
                    addressLine2: row['Address Line 2'],
                    balance: money(row['Balance']),
                    city: row['City'],
                    createdAt: dateOf(row['Created']),
                    email: row['Email'],
                    firstName: row['First Name'],
                    lastActivityAt: dateOf(row['Last Activity']),
                    lastItemAt: dateOf(row['Last Item Entered']),
                    lastName: row['Last Name'],
                    lastSettlementAt: dateOf(row['Last Settlement']),
                    noItems: parseInt(row['Number Of Items']),
                    noSales: parseInt(row['Number Of Sales']),
                    phoneNumber: row['Phone'],
                    postcode: row['Zip'],
                    state: row['State'],
                    deletedAt: dateOf(row['Deactivated']),
                    updatedAt: new Date().toISOString(),
                    lastActivityBy: profile.id,
                    isMobile: isMobileNumber(row['Phone']),
                    comunicationPreferences: comunicationPreferences(row['Phone'], row['Email']),
                    defaultSplit: parseInt(row['Default Split'].replace('%', '')),
                    status: 'Active' as AccountStatus,
                    kind: 'Standard' as AccountKind,
                }
                logger.info(`Creating account : ${JSON.stringify(account)}`);

                const { data, errors } = await client.models.Account.create(newAccount);

                logger.ifErrorThrow('Failed to create account ', errors);

                logger.info('Created account', data);

                logger.info(`Creating account import action: ${data?.number}`);
                const { errors: actionErrors } = await client.models.Action.create({
                    description: `Import of account`,
                    modelName: "Account",
                    type: "Import",
                    typeIndex: "Import",
                    refId: data?.id,
                    userId: IMPORT_SERVICE_USER_ID,
                });
                logger.ifErrorThrow('Failed to create item action', actionErrors);
            }
        }
        logger.info(`Successfully inserted ${data.length} accounts into DynamoDB`);

        // Move the file to the archive folder 
        await archiveFile(bucket, key);

    } catch (error) {
        logger.info('Error processing CSV', error);
        throw error;
    }
};

export function dateOf(datestring?: string | null): string | null {
    if (datestring) {
        return new Date(datestring).toISOString();
    }
    return null;
}
