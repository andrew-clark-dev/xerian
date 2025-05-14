import { Duration, Stack } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as cr from 'aws-cdk-lib/custom-resources';
import * as iam from 'aws-cdk-lib/aws-iam';

interface CreateUserResourceProps {
    userPoolId: string;
    email: string;
    tempPassword: string;
}

export class CreateCognitoUserResource extends Construct {
    constructor(scope: Construct, id: string, props: CreateUserResourceProps) {
        super(scope, id);

        // Lambda function that will create the Cognito user
        const createUserFunction = new lambda.Function(this, 'CreateCognitoUserFunction', {
            runtime: lambda.Runtime.NODEJS_18_X,
            code: lambda.Code.fromAsset('path/to/your/lambda/code'), // adjust as needed
            handler: 'resource.handler',
            timeout: Duration.minutes(1),
            environment: {
                USER_POOL_ID: props.userPoolId,
                NEW_USER_EMAIL: props.email,
                NEW_USER_TEMP_PASSWORD: props.tempPassword,
            },
        });

        // Add permission to create Cognito users
        createUserFunction.addToRolePolicy(
            new iam.PolicyStatement({
                actions: ['cognito-idp:AdminCreateUser'],
                resources: [`arn:aws:cognito-idp:${Stack.of(this).region}:${Stack.of(this).account}:userpool/${props.userPoolId}`],
            })
        );

        // Custom resource to invoke the Lambda once
        new cr.AwsCustomResource(this, 'CreateUserTrigger', {
            onCreate: {
                service: 'Lambda',
                action: 'invoke',
                parameters: {
                    FunctionName: createUserFunction.functionName,
                    InvocationType: 'RequestResponse',
                },
                physicalResourceId: cr.PhysicalResourceId.of('CreateCognitoUserTrigger'),
            },
            policy: cr.AwsCustomResourcePolicy.fromSdkCalls({ resources: [createUserFunction.functionArn] }),
        });
    }
}
