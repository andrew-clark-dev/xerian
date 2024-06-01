
import { Function, LayerVersion } from 'aws-cdk-lib/aws-lambda';
import { Bucket, EventType } from 'aws-cdk-lib/aws-s3';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { Code, Runtime } from 'aws-cdk-lib/aws-lambda';
import { S3EventSourceV2 } from 'aws-cdk-lib/aws-lambda-event-sources';
import { Duration, RemovalPolicy, Stack } from 'aws-cdk-lib';

export function accountImportFunction(stack: Stack, table: ITable): void {
    const bucket = new Bucket(
        stack,
        'import-accounts-bucket');

    const lambdaFunction = new Function(
        stack,
        'account-import-function',
        {
            runtime: Runtime.PYTHON_3_12,
            code: Code.fromAsset('./amplify/custom-resources/account-import/'),
            handler: 'function.handler',
            timeout: Duration.seconds(900),
            memorySize: 1024,
            layers: [LayerVersion.fromLayerVersionArn(
                stack,
                "AWSSDKPandas-Python312-Arm64",
                "arn:aws:lambda:eu-central-1:336392948345:layer:AWSSDKPandas-Python312:8")],
            environment: {
                'BUCKET_NAME': bucket.bucketName,
                'TABLE_NAME': table.tableName
            }
        })

    table.grantWriteData(lambdaFunction)
    bucket.grantRead(lambdaFunction)
    lambdaFunction.addEventSource(
        new S3EventSourceV2(bucket, { events: [EventType.OBJECT_CREATED] }));
}
