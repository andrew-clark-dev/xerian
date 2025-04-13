// services/DynamoService.ts
import { DynamoDBClient, } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, PutCommandInput } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

export class DynamoService {
    private tableName: string;

    constructor(tableName: string) {
        this.tableName = tableName;
    }

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
}