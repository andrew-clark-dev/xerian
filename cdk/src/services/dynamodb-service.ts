// services/DynamoService.ts
import { DynamoDBClient, } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, PutCommandInput, GetCommandInput, GetCommand, UpdateCommand, UpdateCommandInput } from '@aws-sdk/lib-dynamodb';
import { Schema } from '@data-schema';

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

export class DynamoService<T extends Record<string, unknown>> {
    private tableName: string;


    constructor(tableName: string) {
        this.tableName = tableName;
    }

    /**
     * Write an item to the table.
     * @param item The item to write.
     */
    async write<T extends Record<string, unknown>>(item: T): Promise<void> {
        const params: PutCommandInput = {
            TableName: this.tableName,
            Item: item,
        };

        try {
            await ddb.send(new PutCommand(params));
            console.log('Item written successfully:', item);
        } catch (error) {
            console.error('Error writing item:', error);
            throw error;
        }
    }
    /**
     * Read an item from the table using the primary key.
     * @param key The key to read.
     * @returns The item if found, undefined otherwise.
     */
    async read(key: Partial<T>): Promise<T | undefined> {
        const params: GetCommandInput = {
            TableName: this.tableName,
            Key: key,
        };

        try {
            const result = await ddb.send(new GetCommand(params));
            const item = result.Item as T | undefined;
            console.log('Item read successfully:', item);
            return item;
        } catch (error) {
            console.error('Error reading item:', error);
            throw error;
        }
    }
    /**
     * Read an item from the table using a secondary index.
     * @param indexName The name of the secondary index.
     * @param key The key to read.
     * @returns The item if found, undefined otherwise.
     */
    // async readBySecondaryIndex<T extends Record<string, unknown>>(
    //     indexName: string,
    //     key: Partial<T>
    // ): Promise<T | undefined> {
    //     const [keyName, keyValue] = Object.entries(key)[0];

    //     const params: QueryCommandInput = {
    //         TableName: this.tableName,
    //         IndexName: indexName,
    //         KeyConditionExpression: '#key = :value',
    //         ExpressionAttributeNames: {
    //             '#key': keyName,
    //         },
    //         ExpressionAttributeValues: {
    //             ':value': keyValue,
    //         },
    //         Limit: 1,
    //     };

    //     try {
    //         const result = await ddb.send(new QueryCommand(params));
    //         const item = result.Items?.[0] as T | undefined;
    //         console.log(`Item read from index ${indexName}:`, item);
    //         return item;
    //     } catch (error) {
    //         console.error('Error reading from index:', error);
    //         throw error;
    //     }
    // }

    /**
     * Check if an item exists in the table using the primary key.
     * @param key The key to check for existence.
     * @returns True if the item exists, false otherwise.
     */
    async exists(key: Partial<T>): Promise<boolean> {
        const item = await this.read({ ...key });
        return !!item;
    }
    /**
     * Check if an item exists in the table using a secondary index.
     * @param indexName The name of the secondary index.
     * @param key The key to check for existence.
     * @returns True if the item exists, false otherwise.
     */
    // async existsBySecondaryIndex<T extends Record<string, unknown>>(
    //     indexName: string,
    //     key: Partial<T>
    // ): Promise<boolean> {
    //     const item = await this.readBySecondaryIndex(indexName, { ...key });
    //     return !!item;
    // }
    /**
     * Update an item in the table.
     * @param key The key of the item to update.
     * @param updates The updates to apply.
     * @usage 
     * await myDynamoService.update(
     *  { id: '123' },
     *  { status: 'complete', updatedAt: Date.now() }
     * );
     */
    async update(key: Partial<T>, updates: Partial<T>): Promise<void> {

        const updateExpressions = Object.keys(updates).map((k, i) => `#key${i} = :val${i}`);
        const expressionAttributeNames = Object.keys(updates).reduce((acc, k, i) => {
            acc[`#key${i}`] = k;
            return acc;
        }, {} as Record<string, string>);
        const expressionAttributeValues = Object.values(updates).reduce((acc, v, i) => {
            acc[`:val${i}`] = v;
            return acc;
        }, {} as Record<string, unknown>);

        const params: UpdateCommandInput = {
            TableName: this.tableName,
            Key: key,
            UpdateExpression: `SET ${updateExpressions.join(', ')}`,
            ExpressionAttributeNames: expressionAttributeNames,
            ExpressionAttributeValues: expressionAttributeValues,
        };

        try {
            await ddb.send(new UpdateCommand(params));
            console.log('Item updated successfully');
        } catch (error) {
            console.error('Error updating item:', error);
            throw error;
        }
    }

    /**
     * Append values to an array attribute in the table.
     * @param key The key of the item to update.
     * @param arrayAttrName The name of the array attribute to append to.
     * @param valuesToAppend The values to append.
     * @usage
     * await myDynamoService.appendToArray(
     *  { id: '123' },
     *  'tags',
     *  ['featured', 'new']
     * );
     * This will append ['featured', 'new'] to the existing tags array for the item with id: '123'
     */
    async appendToArray<T extends Record<string, unknown>>(
        key: Partial<T>,
        arrayAttrName: string,
        valuesToAppend: unknown[]
    ): Promise<void> {
        const params: UpdateCommandInput = {
            TableName: this.tableName,
            Key: key,
            UpdateExpression: `SET #arr = list_append(if_not_exists(#arr, :empty_list), :values)`,
            ExpressionAttributeNames: {
                '#arr': arrayAttrName,
            },
            ExpressionAttributeValues: {
                ':values': valuesToAppend,
                ':empty_list': [],
            },
        };

        try {
            await ddb.send(new UpdateCommand(params));
            console.log(`Appended to array '${arrayAttrName}' successfully`);
        } catch (error) {
            console.error(`Error appending to array '${arrayAttrName}':`, error);
            throw error;
        }
    }
}

export const userDbService = new DynamoService<Schema['UserProfile']['type']>(process.env.USERPROFILE_TABLE!);
export const accountDbService = new DynamoService<Schema['Account']['type']>(process.env.ACCOUNT_TABLE!);
export const itemDbService = new DynamoService<Schema['Item']['type']>(process.env.ITEM_TABLE!);
export const itemGroupDbService = new DynamoService<Schema['ItemGroup']['type']>(process.env.ITEM_GROUP_TABLE!);
export const saleDbService = new DynamoService<Schema['Sale']['type']>(process.env.SALE_TABLE!);
export const transactionDbService = new DynamoService<Schema['Transaction']['type']>(process.env.TRANSACTION_TABLE!);
export const itemCategoryDbService = new DynamoService<Schema['ItemCategory']['type']>(process.env.ITEMCATEGORY_TABLE!);


export interface DynamoServices {
    user: DynamoService<Schema['UserProfile']['type']>;
    account: DynamoService<Schema['Account']['type']>;
    item: DynamoService<Schema['Item']['type']>;
    itemGroup: DynamoService<Schema['ItemGroup']['type']>;
    sale: DynamoService<Schema['Sale']['type']>;
    transaction: DynamoService<Schema['Transaction']['type']>;
    itemCategory: DynamoService<Schema['ItemCategory']['type']>;
}

export const dynamoServices: DynamoServices = {
    user: userDbService,
    account: accountDbService,
    item: itemDbService,
    itemGroup: itemGroupDbService,
    sale: saleDbService,
    transaction: transactionDbService,
    itemCategory: itemCategoryDbService,
}