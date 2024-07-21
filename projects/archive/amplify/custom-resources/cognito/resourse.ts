import { IUserPool } from "aws-cdk-lib/aws-cognito";
import { Secret } from "aws-cdk-lib/aws-secretsmanager";
import { Stack } from "aws-cdk-lib";
import { UserPoolUser } from "./UserPoolUser";

export function createAdminUser(
    stack: Stack,
    email: string,
    userPool: IUserPool,
    groupName: string,
): UserPoolUser {
    const secret = Secret.fromSecretNameV2(stack, 'Secret-AdminUser', 'dev/xerian/admin-user-credentials');
    return new UserPoolUser(stack, 'auth-admin-user', {
        userPool,
        username: email,
        password: secret.secretValueFromJson('password').unsafeUnwrap(),
        attributes: [
            { Name: 'email', Value: email },
            { Name: 'email_verified', Value: 'true' },
            { Name: 'name', Value: 'Admin User' },
        ],
        groupName: groupName,
    });
}
