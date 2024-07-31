
import { Function, IEventSource, LayerVersion } from 'aws-cdk-lib/aws-lambda';
import { EventType, IBucket, NotificationKeyFilter } from 'aws-cdk-lib/aws-s3';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { Code, Runtime } from 'aws-cdk-lib/aws-lambda';
import { Duration, Stack } from 'aws-cdk-lib';
import { S3EventSourceV2, S3EventSourceProps } from 'aws-cdk-lib/aws-lambda-event-sources';

export function backendFunction(
    stack: Stack,
    functionName: string,
    environment: { [key: string]: string; },
    tables?: ITable[],
    buckets?: IBucket[],
    eventSource?: IEventSource,
    timeout: Duration = Duration.seconds(300), // Default 5 minutes 
    memorySize: number = 1024,
): Function {
    console.log(`Creating function - ${functionName}`);
    console.log(`With env - ${environment}`);

    const lambdaFunction = new Function(
        stack,
        `${functionName}-function`,
        {
            runtime: Runtime.PYTHON_3_12,
            code: Code.fromAsset(`./amplify/function/${functionName}/`),
            handler: 'function.handler',
            timeout: timeout,
            memorySize: memorySize,
            layers: [LayerVersion.fromLayerVersionArn(
                stack,
                `AWSSDKPandas-Python312-Arm64-${functionName}`,
                'arn:aws:lambda:eu-central-1:336392948345:layer:AWSSDKPandas-Python312:8')],
            environment: environment
        })

    tables?.forEach((table) => {
        table.grantFullAccess(lambdaFunction)
    })

    buckets?.forEach((bucket) => {
        bucket.grantReadWrite(lambdaFunction)
    })

    if (eventSource) {
        lambdaFunction.addEventSource(eventSource)
        if (eventSource) console.log(`EventSource added`)
    }

    return lambdaFunction
}


export function s3EventFunction(
    stack: Stack,
    functionName: string,
    environment: { [key: string]: string; } = {},
    tables: ITable[],
    bucket: IBucket,
    filter: NotificationKeyFilter,
    timeout: Duration = Duration.seconds(60), // Default one minute 
    memorySize: number = 1024,
): Function {
    console.log(`Creating S3 event function - ${functionName}`);
    const props: S3EventSourceProps = { events: [EventType.OBJECT_CREATED], filters: [filter] };
    const eventSource = new S3EventSourceV2(bucket, props);
    return backendFunction(stack, functionName, environment, tables, [bucket], eventSource, timeout, memorySize,);
}

export function accountImport(environment: { [key: string]: string; }, table: ITable, bucket: IBucket): Function {
    console.log(`Creating Account Import function`);
    const bucketStack = Stack.of(bucket);
    const filter: NotificationKeyFilter = { prefix: 'uploads/import/Account', suffix: 'csv' };
    return s3EventFunction(bucketStack, 'account-import', environment, [table], bucket, filter, Duration.seconds(300));
}

export function itemImport(environment: { [key: string]: string; }, tables: ITable[], bucket: IBucket): Function {
    console.log(`Creating Item Import function`);
    const bucketStack = Stack.of(bucket);
    const filter: NotificationKeyFilter = { prefix: 'uploads/import/Item', suffix: 'csv' };
    return s3EventFunction(bucketStack, 'item-import', environment, tables, bucket, filter, Duration.seconds(300));
}


export function truncateTable(tables: ITable[]): Function {
    console.log(`Creating Account Import function`);
    const tableStack = Stack.of(tables[0]);
    return backendFunction(tableStack, 'truncate-table', {}, tables, []);
}