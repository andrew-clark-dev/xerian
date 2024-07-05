import { Construct } from "constructs";
import { CfnUserPoolGroup, CfnUserPoolUser, CfnUserPoolUserToGroupAttachment, IUserPool } from "aws-cdk-lib/aws-cognito";
import { Secret } from "aws-cdk-lib/aws-secretsmanager";


export class AdminUser extends Construct {

    cfnUserPoolUser: CfnUserPoolUser;

    constructor(scope: Construct, id: string, props: {
        userPool: IUserPool,
        email: string,
        group?: CfnUserPoolGroup,
    }) {
        super(scope, id);

        // Templated secret with username and password fields
        const adminCredSecret = new Secret(this, 'dev/xerian/admin-user-credentials', {
            generateSecretString: {
                secretStringTemplate: JSON.stringify({ username: props.email }),
                generateStringKey: 'password',
                excludeCharacters: '/@"',
            },
        });

        const ADMIN_USERNAME = props.email;
        const TEMPORARY_PASSWORD = adminCredSecret.secretValueFromJson('password').unsafeUnwrap()


        this.cfnUserPoolUser = new CfnUserPoolUser(this, 'XerianAdminUser', {
            userPoolId: props.userPool.userPoolId,

            // the properties below are optional
            desiredDeliveryMediums: ['EMAIL'],
            forceAliasCreation: false,
            messageAction: 'RESEND',
            username: ADMIN_USERNAME,
            userAttributes: [
                { name: 'email', value: ADMIN_USERNAME },
                { name: 'email_verified', value: 'true' },
                { name: 'name', value: ADMIN_USERNAME },
            ],
        });

        // If a Group Name is provided, also add the user to this Cognito UserPool Group
        if (props.group) {
            const cfnUserPoolUserToGroupAttachment = new CfnUserPoolUserToGroupAttachment(this, 'AdminUserPoolUserToGroupAttachment', {
                groupName: props.group.groupName!,
                username: ADMIN_USERNAME,
                userPoolId: props.userPool.userPoolId,
            });
            cfnUserPoolUserToGroupAttachment.node.addDependency(this.cfnUserPoolUser);
            cfnUserPoolUserToGroupAttachment.node.addDependency(props.group);
            cfnUserPoolUserToGroupAttachment.node.addDependency(props.userPool);
        }
    }
}
