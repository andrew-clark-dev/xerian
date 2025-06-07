import { provisionUser } from '../../src/user-service';
import { v4 as uuidv4 } from 'uuid';

interface ProvisionUserEvent {
    id?: string;
    username: string;
    email: string;
    temporaryPassword?: string | undefined;
}

// Lambda handler for provisioning a user
export const handler = async (event: ProvisionUserEvent) => {
    try {
        const { id, username, email, temporaryPassword } = event;
        if (!username || !email) {
            return {
                statusCode: 400,
                body: JSON.stringify({ error: 'Missing required parameters: username and email' }),
            };
        }

        await provisionUser(id ?? uuidv4(), username, email, temporaryPassword);

        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'User provisioned successfully' }),
        };
    } catch (error) {
        let errorMessage = 'Internal server error';
        if (error instanceof Error) {
            errorMessage = error.message;
        }
        return {
            statusCode: 500,
            body: JSON.stringify({ error: errorMessage }),
        };
    }
};