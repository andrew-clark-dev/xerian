import { Schema } from "../../amplify/data/resource"; // Adjusted the path to the correct module
import { v4 as uuid4 } from 'uuid';
import { serverClient } from "./amplify-server-utils";

export type Notification = Schema['Notification']['type'];

const client = serverClient;

type NotificationType = 'Failure' | 'Success' | 'Start' | 'Alert' | 'Fatal';

class NotificationService {


    async notify(notificationType: NotificationType, functionName: string, message: string, data?: unknown): Promise<Notification> {
        const { data: notification, errors: errors } = await client.models.Notification.create(
            {
                id: uuid4(),
                createdAt: new Date().toISOString(),
                type: notificationType,
                functionName: functionName,
                message: message,
                data: JSON.stringify(data),
                pid: process.pid.toString(),
            }
        );
        if (errors) {
            throw new Error(`Failed to create notinfication for : ${functionName} - ${JSON.stringify(errors)}`);
        }
        return notification!;
    }


}

export const notificationService = new NotificationService();