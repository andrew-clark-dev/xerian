import { Schema } from "../../amplify/data/resource"; // Adjusted the path to the correct module
import { generateClient } from "aws-amplify/data";

export type Notification = Schema['Notification']['type'];

const client = generateClient<Schema>();

type NotificationType = 'Failure' | 'Success' | 'Start' | 'Alert' | 'Fatal';

class NotificationService {


    async notify(notificationType: NotificationType, functionName: string, message: string, data?: unknown): Promise<Notification> {

        const { data: notification, errors: errors } = await client.models.Notification.create(
            {
                type: notificationType,
                functionName: functionName,
                message: message,
                data: JSON.stringify(data),
            }
        );
        if (errors) {
            throw new Error(`Failed to create notinfication for : ${functionName} - ${JSON.stringify(errors)}`);
        }
        return notification!;
    }


}

export const notificationService = new NotificationService();