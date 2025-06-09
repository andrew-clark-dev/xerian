import { provisionUser } from '../../src/user-service';
import { v4 as uuidv4 } from 'uuid';

interface ProvisionUserData {
    id?: string;
    username: string;
    email: string;
    temporaryPassword?: string | undefined;
}

// Lambda handler for provisioning a user or list of users
export const handler = async (event: ProvisionUserData | ProvisionUserData[]) => {
    try {
        const inputs = Array.isArray(event) ? event : [event];

        const normalizedInputs = inputs.map((input) => ({
            ...input,
            id: input.id ?? uuidv4(),
        }));

        const result = await provisionUser(normalizedInputs);

        return {
            statusCode: 200,
            body: JSON.stringify({
                message: Array.isArray(event)
                    ? 'Users provisioned successfully'
                    : 'User provisioned successfully',
                result,
            }),
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