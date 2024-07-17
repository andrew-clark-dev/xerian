import { IUserPool } from "aws-cdk-lib/aws-cognito";
import { Secret } from "aws-cdk-lib/aws-secretsmanager";
import { Stack } from "aws-cdk-lib";
import { UserPoolUser } from "./UserPoolUser";
import generator from 'generate-password-ts';

export function createAdminUser(
    stack: Stack,
    email: string,
    userPool: IUserPool,
    groupName: string,
): UserPoolUser {
    // Random password that the admin will have to reset anyway.
    const init_password = generator.generate({
        length: 20,
        numbers: true
    });
    return new UserPoolUser(stack, 'auth-admin-user', {
        userPool,
        username: email,
        password: init_password,
        attributes: [
            { Name: 'email', Value: email },
            { Name: 'email_verified', Value: 'true' },
            { Name: 'name', Value: 'Admin User' },
        ],
        groupName: groupName,
    });
}
