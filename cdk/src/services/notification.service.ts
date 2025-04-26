import { v4 as uuid4 } from 'uuid';
import { DynamoService } from "./dynamodb-service";


type NotificationType = 'Failure' | 'Success' | 'Start' | 'Alert' | 'Fatal';

const tableName = process.env.NOTIFICATION_TABLE;

class NotificationService {


    async notify(notificationType: NotificationType, functionName: string, message: string, data?: unknown): Promise<void> {
        try {
            const dynamoService = new DynamoService(tableName!);
            const item = {
                __typename: 'Notification',
                id: uuid4(),
                createdAt: new Date().toISOString(),
                type: notificationType.toString(),
                functionName: functionName,
                message: message,
                data: JSON.stringify(data),
                pid: process.pid.toString(),
            };

            await dynamoService.write(item);

        }
        catch (error) {
            console.error(`Failed to create notification for ${functionName} - ${message}`, error);
            throw error;
        }


    }
}

export const notificationService = new NotificationService();

