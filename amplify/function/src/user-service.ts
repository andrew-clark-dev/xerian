import { UserType } from '@aws-sdk/client-cognito-identity-provider';
import generator from 'generate-password';
import { DynamoService } from "./dynamodb-service";

import {
    CognitoIdentityProviderClient,
    AdminCreateUserCommand,
    AdminCreateUserCommandInput,
    AdminGetUserCommand
} from '@aws-sdk/client-cognito-identity-provider';

const client = new CognitoIdentityProviderClient({});

const DEFAULT_SETTINGS = JSON.stringify({
    notifications: true,
    theme: 'light',
    hasLogin: true,
})

/**
 * Generates a random password that satisfies Cognito default rules:
 * - Min 8 characters
 * - At least one uppercase, lowercase, digit, and special character
 */
function generateSecurePassword(): string {
    return generator.generate({
        length: 12,
        numbers: true,
        symbols: true,
        uppercase: true,
        lowercase: true,
        strict: true, // Enforces at least one character from each selected pool
    });
}

/**
 * Creates a new user in AWS Cognito User Pool.
 * @param username The desired username.
 * @param email The user's email address.
 * @param temporaryPassword Optional: The initial temporary password. If omitted, a random secure password is used.
 */
export async function createCognitoUser(
    username: string,
    email: string,
    temporaryPassword?: string | null
): Promise<UserType> {
    const userPoolId = process.env.USER_POOL_ID;
    if (!userPoolId) {
        throw new Error('USER_POOL_ID environment variable is not set');
    }

    const password = temporaryPassword || generateSecurePassword();

    const input: AdminCreateUserCommandInput = {
        UserPoolId: userPoolId,
        Username: username,
        TemporaryPassword: password,
        UserAttributes: [
            { Name: 'email', Value: email },
            // Confirm the email upon creation
            { Name: 'email_verified', Value: 'true' }
        ],
        MessageAction: 'SUPPRESS', // Remove this if you want Cognito to send a welcome email
    };

    try {
        const command = new AdminCreateUserCommand(input);
        const response = await client.send(command);
        console.log('User created:', response.User?.Username);
        return response.User!;
    } catch (error) {
        console.error('Failed to create user:', error);
        throw error;
    }
}

import { AdminAddUserToGroupCommand } from '@aws-sdk/client-cognito-identity-provider';

/**
 * Adds a Cognito user to a specified group.
 * @param username The username of the user.
 * @param groupName The name of the group.
 */
export async function addUserToGroup(username: string, groupName: string): Promise<void> {
    const userPoolId = process.env.USER_POOL_ID;
    if (!userPoolId) {
        throw new Error('USER_POOL_ID environment variable is not set');
    }

    const input = {
        UserPoolId: userPoolId,
        Username: username,
        GroupName: groupName
    };

    try {
        const command = new AdminAddUserToGroupCommand(input);
        await client.send(command);
        console.log(`User ${username} added to group ${groupName}`);
    } catch (error) {
        console.error('Failed to add user to group:', error);
        throw error;
    }
}

import { AdminRemoveUserFromGroupCommand } from '@aws-sdk/client-cognito-identity-provider';

/**
 * Removes a Cognito user from a specified group.
 * @param username The username of the user.
 * @param groupName The name of the group.
 */
export async function removeUserFromGroup(username: string, groupName: string): Promise<void> {
    const userPoolId = process.env.USER_POOL_ID;
    if (!userPoolId) {
        throw new Error('USER_POOL_ID environment variable is not set');
    }

    const input = {
        UserPoolId: userPoolId,
        Username: username,
        GroupName: groupName
    };

    try {
        const command = new AdminRemoveUserFromGroupCommand(input);
        await client.send(command);
        console.log(`User ${username} removed from group ${groupName}`);
    } catch (error) {
        console.error('Failed to remove user from group:', error);
        throw error;
    }
}

import { AdminSetUserPasswordCommand } from '@aws-sdk/client-cognito-identity-provider';

/**
 * Resets a Cognito user's password.
 * @param username The username of the user.
 * @param newPassword The new password to set.
 */
export async function resetUserPassword(username: string, newPassword: string): Promise<void> {
    const userPoolId = process.env.USER_POOL_ID;
    if (!userPoolId) {
        throw new Error('USER_POOL_ID environment variable is not set');
    }

    const input = {
        UserPoolId: userPoolId,
        Username: username,
        Password: newPassword,
        Permanent: true // Set to true to avoid requiring password reset on next sign-in
    };

    try {
        const command = new AdminSetUserPasswordCommand(input);
        await client.send(command);
        console.log(`Password for user ${username} has been reset.`);
    } catch (error) {
        console.error('Failed to reset user password:', error);
        throw error;
    }
}

const profileTableName = process.env.USERPROFILE_TABLE_NAME!;

interface UserProfileDb {
    id: string;
    sub: string;
    email: string;
    username: string;
    enabled: boolean;
    settings?: string;
}

/**
 * Creates a user profile in DynamoDB and returns the created profile object.
 * @param user The minimal user information.
 * @returns The created user profile object.
 */
export async function createUserProfileDb(user: UserProfileDb): Promise<void> {
    try {
        const dynamoService = new DynamoService(profileTableName!);
        // Build the profile object with __typename, then remove it before writing/returning
        const profile = {
            __typename: 'UserProfileDb',
            id: user.id,
            sub: user.sub,
            email: user.email,
            username: user.username,
            enabled: user.enabled || false,
            status: user.enabled ? 'Active' : 'Inactive',
            role: 'Employee',
            settings: user.settings || DEFAULT_SETTINGS,
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString(),
        };
        await dynamoService.write(profile);
    }
    catch (error) {
        console.error(`Failed to create user for ${user?.username}`, error);
        throw error;
    }
}

export interface ProvisionUserData {
    id: string,
    username: string,
    email: string,
    temporaryPassword?: string | null,
}

export async function provisionUser(
    input: ProvisionUserData | ProvisionUserData[]
): Promise<string | string[]> {
    const inputs = Array.isArray(input) ? input : [input];

    const results: string[] = [];

    for (const item of inputs) {
        const userPoolId = process.env.USER_POOL_ID;
        if (!userPoolId) {
            throw new Error('USER_POOL_ID environment variable is not set');
        }

        try {
            const getUser = new AdminGetUserCommand({
                UserPoolId: userPoolId,
                Username: item.username
            });
            const existing = await client.send(getUser);
            const sub = existing.UserAttributes?.find(attr => attr.Name === 'sub')?.Value;
            results.push(sub!);
            continue;
        } catch {
            // User not found, continue to create
        }

        const user = await createCognitoUser(item.username, item.email, item.temporaryPassword);

        const sub = user.Attributes?.find(attr => attr.Name === 'sub')?.Value;
        const email = user.Attributes?.find(attr => attr.Name === 'email')?.Value;
        const username = user.Username || item.username;
        const enabled = user.Enabled || false;

        const userProfile: UserProfileDb = {
            id: item.id,
            sub: sub!,
            email: email!,
            username,
            enabled,
            settings: DEFAULT_SETTINGS,
        };

        await createUserProfileDb(userProfile);
        results.push(sub!);
    }

    return Array.isArray(input) ? results : results[0];
}
