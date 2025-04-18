// import type { S3Event, S3Handler } from "aws-lambda";
// import { Schema } from "../resource";
// // import { env } from "$amplify/env/import-item-function";
// import Papa from "papaparse";
// import { archiveFile, fromEvent, s3body } from "@server/file.utils";
// import { userService } from "@server/user.service";
// import { logger } from "@server/logger";
// import { toISO, money, split } from "@server/import.utils";
// import { IMPORT_SERVICE_USER_ID } from "../constants";
// // import { getClient } from "@server/client.utils";

// type ItemCategoryKind = Schema['ItemCategoryKind']['type']
// type ItemStatus = Schema['ItemStatus']['type']

// // const client = await getClient(env);

// // Initialize AWS clients


// interface Row {
//     'SKU': string,
//     'Created': string,
//     'Created By': string,
//     'Deleted': string,
//     'Brand': string,
//     'Color': string,
//     'Size': string,
//     'Details': string,
//     'Description': string,
//     'Title': string,
//     'Account': string,
//     'Account Name': string,
//     'Account Company': string,
//     'Category': string,
//     'Shelf': string,
//     'Cost Per': string,
//     'Split Price': string,
//     'Tag Price': string,
//     'Tags': string,
//     'Tax Exempt': string,
//     'Split': string,
//     'Inventory Type': string,
//     'Terms': string,
//     'Active': string,
//     'Expired': string,
//     'Lost': string,
//     'Damaged': string,
//     'Donated': string,
//     'Stolen': string,
//     'To Be Returned': string,
//     'Returned To Owner': string,
//     'Sold': string,
//     'Parked': string,
//     'Number Of Images': string,
//     'Status': string,
//     'Quantity': string,
//     'Expires': string,
//     'Schedule Start': string,
//     'Days On Shelf': string,
//     'Printed': string,
//     'Batch': string,
//     'Surcharges': string,
//     'Last Sold': string,
//     'Last Viewed': string,
//     'Sales': string,
//     'Refunds': string,
//     'Historic Sale Price': string,
//     'Historic Split Price': string,
//     'Historic Consignor Portion': string,
//     'Historic Store Portio': string,
// }


// /**
//  * Lambda Handler Function
//  */
// export const handler: S3Handler = async (event: S3Event): Promise<void> => {
//     logger.info(`S3 event: ${JSON.stringify(event)}`);
//     try {
//         const { bucket, key } = fromEvent(event)
//         logger.start(`Processing file: s3://${bucket}/${key}`, event);

//         // Get the file contents from S3
//         const body = await s3body(event);

//         // Parse CSV data
//         const csvContent = body.toString("utf-8");
//         const { data } = Papa.parse<Row>(csvContent, { header: true });

//         // Initailize statisitics
//         let errorCount = 0;
//         let added = 0;
//         let skipped = 0;

//         for (const row of data) {
//             const nickname = row['Created By']
//             const profile = await userService.provisionUser(nickname);
//             try {
//                 const processed = await createItem(row, profile.id);
//                 added += processed;
//                 skipped += (1 - processed);
//             } catch (error) {
//                 errorCount++;
//                 logger.failure(`Error ${error} - creating item from row`, row);
//             }
//         }

//         logger.success(`Successfully processed ${data.length} rows, ${added} added, ${skipped} skipped, with ${errorCount} errors`);

//         // Move the file to the archive folder 
//         await archiveFile(bucket, key, errorCount);

//     } catch (error) {
//         logger.info((`Error processing CSV: ${JSON.stringify(error)}`));
//         throw error;
//     }
// };

// async function createGroup(row: Row) {
//     const quantity = parseInt(row['Quantity'] || '1');
//     if (quantity > 1) {
//         logger.info(`Creating item group: ${row['SKU']}`);
//         const { data: groupData, errors: groupErrors } = await client.models.ItemGroup.create({
//             quantity,
//             itemSku: row['SKU'],
//             statuses: toStatuses(row['Status']),

//         });
//         logger.ifErrorThrow('Failed to create item group', groupErrors);
//         logger.info(`Created item group`, groupData);
//     }
// }

// async function createItem(row: Row, id: string): Promise<number> {
//     logger.info('Process', row);
//     const item = await client.models.Item.get({ sku: row['SKU'] });
//     if (item.data) {
//         logger.info(`Item already exists:`, item.data);
//         return 0;
//     }

//     await createGroup(row);

//     const newItem = {
//         sku: row['SKU'],
//         lastActivityBy: id,
//         title: row['Title'],
//         accountNumber: row['Account'],
//         category: indexString(row['Category']),
//         brand: indexString(row['Brand']),
//         color: indexString(row['Color']),
//         size: indexString(row['Size']),
//         description: row['Description'],
//         details: row['Details'],
//         condition: 'NotSpecified' as const,
//         split: split(row['Split']),
//         price: money(row['Tag Price']),
//         status: toStatus(row['Status']),
//         printedAt: toISO(row['Printed']),
//         lastSoldAt: toISO(row['Last Sold']),
//         lastViewedAt: toISO(row['Last Viewed']),
//         createdAt: toISO(row['Created']),
//         updatedAt: new Date().toISOString(),
//         deletedAt: toISO(row['Deleted']),
//     }

//     logger.info(`Creating item : ${JSON.stringify(newItem)}`);

//     const { data, errors } = await client.models.Item.create(newItem);

//     logger.ifErrorThrow('Failed to create item ', errors);

//     logger.info('Created item', data);

//     logger.info(`Creating item import action: ${data?.sku}`);
//     const { errors: actionErrors } = await client.models.Action.create({
//         description: `Import of item`,
//         modelName: "Item",
//         type: "Import",
//         typeIndex: "Import",
//         refId: data?.id,
//         userId: IMPORT_SERVICE_USER_ID,
//     });
//     logger.ifErrorThrow('Failed to create item action', actionErrors);

//     await createCategory('Category', row['Category']);
//     await createCategory('Brand', row['Brand']);
//     await createCategory('Color', row['Color']);
//     await createCategory('Size', row['Size']);

//     return 1;
// }


// const categories: string[] = [];

// async function createCategory(kind: ItemCategoryKind, value?: string | null) {

//     try {
//         if (value) {
//             logger.info(`Create category : ${kind} - ${value}`);
//             if (categories.includes(kind + value)) {
//                 logger.info(`Category found in cach, do nothing`);
//                 return;
//             }
//             const category = await client.models.ItemCategory.get({ kind, name: value });
//             if (category.data) {
//                 logger.info('Category already exists', category.data);
//             } else {
//                 logger.info(`Creating ${kind}: ${value}`);
//                 const category = await client.models.ItemCategory.create({
//                     lastActivityBy: IMPORT_SERVICE_USER_ID,
//                     categoryKind: kind,
//                     kind: kind,
//                     name: value,
//                     matchNames: value,
//                 });
//                 if (category.errors) {
//                     logger.warn(`Failed to create category: ${kind}: ${value}`); // this is probably a race condition.
//                     return;
//                 }
//                 logger.info('Created category', category.data);
//             }
//             // cache the category
//             categories.push(kind + value);
//         }
//     } catch (error) {
//         logger.ifErrorThrow(`Error creating category: ${kind}: ${value}`, error);
//     }
// }

// function indexString(value?: string): string | null {
//     if (!value) {
//         return null;
//     } else if (value.trim() == '') {
//         return null;
//     }
//     return value;
// }

// export function toStatuses(status: string): ItemStatus[] {
//     const statuses: ItemStatus[] = [];

//     status.split(',').forEach((s) => {
//         const st = s.split(' ');
//         const count = parseInt(st[0]);
//         for (let i = 0; i < count; i++) {
//             statuses.push(st[1].trim() as ItemStatus);
//         }

//     });
//     return statuses;
// }

// export function toStatus(status: string): ItemStatus {
//     const statuses = toStatuses(status);
//     if (statuses.length == 0) {
//         return 'Unknown';
//     } else if (statuses.length == 1) {
//         return statuses[0];
//     } else {
//         return 'Multi';
//     }
// }
