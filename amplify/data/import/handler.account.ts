import type { S3Handler } from "aws-lambda";
import { Schema } from "../resource";
import { logger } from "@server/logger";

import { env } from "$amplify/env/import-account-function";
import Papa from "papaparse";
import { archiveFile, fromEvent, s3body } from "@server/file.utils";

import { money, isMobileNumber, comunicationPreferences } from "@server/import.utils";
import { userService } from "@server/user.service";
import { IMPORT_SERVICE_USER_ID } from "../constants";
import { getClient } from "@server/client.utils";

export type AccountStatus = Schema['Account']['type']['status'];
export type AccountKind = Schema['Account']['type']['kind'];


const client = await getClient(env);

/**
 * Lambda Handler Function
 */

export interface Row {
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
        const { bucket, key } = fromEvent(event)
        logger.start(`Processing file: s3://${bucket}/${key}`, event);

        // Get the file contents from S3
        const body = await s3body(event);

        // Parse CSV data
        const csvContent = body.toString("utf-8");
        const { data } = Papa.parse<Row>(csvContent, { header: true });

        // Initailize statisitics
        let errorCount = 0;
        let added = 0;
        let skipped = 0;

        for (const row of data) {
            const nickname = row['Created By']
            const profile = await userService.provisionUser(nickname);
            const account = await client.models.Account.get({ number: row['Number'] });
            if (account.data) {
                logger.info('Account already exists', account.data);
                skipped++;
            } else {

                try {
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
                    added++;
                } catch (error) {
                    errorCount++;
                    logger.failure(`Error ${error} - creating item from row`, row);
                }
            }
        }
        logger.success(`Successfully processed ${data.length} rows, ${added} added, ${skipped} skipped, with ${errorCount} errors`);

        // Move the file to the archive folder 
        await archiveFile(bucket, key, errorCount);

    } catch (error) {
        logger.failure('Error processing CSV', error);
        throw error;
    }
};

export function dateOf(datestring?: string | null): string | null {
    if (datestring) {
        return new Date(datestring).toISOString();
    }
    return null;
}
