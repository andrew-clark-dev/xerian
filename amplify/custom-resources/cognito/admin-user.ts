import { Construct } from "constructs";
import { CfnUserPool, CfnUserPoolGroup, CfnUserPoolUserToGroupAttachment } from "aws-cdk-lib/aws-cognito";
import { Secret } from "aws-cdk-lib/aws-secretsmanager";
import { generate } from 'generate-passphrase';
import { SecretValue } from "aws-cdk-lib";
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from "aws-cdk-lib/custom-resources";

export class AdminlUser extends Construct {

    constructor(scope: Construct, id: string, props: {
        cfnUserPool: CfnUserPool,
        email: string,
        groupName?: string,
    }) {
        super(scope, id);

        // modify cfnUserPool policies directly
        props.cfnUserPool.policies = {
            passwordPolicy: {
                minimumLength: 20,
                requireLowercase: true,
                requireNumbers: true,
                requireSymbols: false,
                requireUppercase: false,
                temporaryPasswordValidityDays: 20,
            }
        }

        var passphrase = "";

        while (passphrase.length < 20) {
            passphrase = generate();
        }

        // Templated secret with username and password fields
        const adminCredSecret = new Secret(this, 'dev/xerian/admin-user-credentials', {
            secretObjectValue: {
                username: SecretValue.unsafePlainText(props.email),
                password: SecretValue.unsafePlainText(passphrase),
            },
        });

        // Create the user inside the Cognito user pool using Lambda backed AWS Custom resource
        const adminCreateUser = new AwsCustomResource(this, 'AwsCustomResource-CreateUser', {
            onCreate: {
                service: 'CognitoIdentityServiceProvider',
                action: 'adminCreateUser',
                parameters: {
                    UserPoolId: props.cfnUserPool.attrUserPoolId,
                    Username: props.email,
                    MessageAction: 'SUPPRESS',
                    TemporaryPassword: passphrase,
                    userAttributes: [
                        { name: "email", value: props.email },
                        { name: "email_verified", value: "true" },
                    ],
                },
                physicalResourceId: PhysicalResourceId.of(`AwsCustomResource-CreateUser-${props.email}`),
            },
            onDelete: {
                service: "CognitoIdentityServiceProvider",
                action: "adminDeleteUser",
                parameters: {
                    UserPoolId: props.cfnUserPool.attrUserPoolId,
                    Username: props.email,
                },
            },
            policy: AwsCustomResourcePolicy.fromSdkCalls({ resources: AwsCustomResourcePolicy.ANY_RESOURCE }),
            installLatestAwsSdk: true,
        });

        // Force the password for the user, because by default when new users are created
        // they are in FORCE_PASSWORD_CHANGE status. The newly created user has no way to change it though
        const adminSetUserPassword = new AwsCustomResource(this, 'AwsCustomResource-ForcePassword', {
            onCreate: {
                service: 'CognitoIdentityServiceProvider',
                action: 'adminSetUserPassword',
                parameters: {
                    UserPoolId: props.cfnUserPool.attrUserPoolId,
                    Username: props.email,
                    Password: passphrase,
                    Permanent: true,
                },
                physicalResourceId: PhysicalResourceId.of(`AwsCustomResource-ForcePassword-${props.email}`),
            },
            policy: AwsCustomResourcePolicy.fromSdkCalls({ resources: AwsCustomResourcePolicy.ANY_RESOURCE }),
            installLatestAwsSdk: true,
        });
        adminSetUserPassword.node.addDependency(adminCreateUser);

        // If a Group Name is provided, also add the user to this Cognito UserPool Group
        if (props.groupName) {
            const userToAdminsGroupAttachment = new CfnUserPoolUserToGroupAttachment(this, 'AttachAdminToAdminsGroup', {
                userPoolId: props.cfnUserPool.attrUserPoolId,
                groupName: props.groupName,
                username: props.email,
            });
            userToAdminsGroupAttachment.node.addDependency(adminCreateUser);
            userToAdminsGroupAttachment.node.addDependency(adminSetUserPassword);
            userToAdminsGroupAttachment.node.addDependency(props.cfnUserPool);
        }
    }
}
