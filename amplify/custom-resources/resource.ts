
import { Function, IEventSource, LayerVersion } from 'aws-cdk-lib/aws-lambda';
import { IBucket } from 'aws-cdk-lib/aws-s3';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { Code, Runtime } from 'aws-cdk-lib/aws-lambda';
import { Duration, Stack } from 'aws-cdk-lib';

export function backendFunction(
    stack: Stack,
    functionName: string,
    environment: { [key: string]: string; },
    tables: ITable[] = [],
    buckets: IBucket[] = [],
    eventSource?: IEventSource,
): Function {
    console.log(`Creating function - ${functionName}`);
    console.log(`With environment - `);
    for (const name in environment) { console.log(`${name} = ${environment[name]}`) }

    const lambdaFunction = new Function(
        stack,
        `${functionName}-function`,
        {
            runtime: Runtime.PYTHON_3_12,
            code: Code.fromAsset(`./amplify/custom-resources/${functionName}/`),
            handler: 'function.handler',
            timeout: Duration.seconds(900),
            memorySize: 1024,
            layers: [LayerVersion.fromLayerVersionArn(
                stack,
                `AWSSDKPandas-Python312-Arm64-${functionName}`,
                'arn:aws:lambda:eu-central-1:336392948345:layer:AWSSDKPandas-Python312:8')],
            environment: environment
        })

    tables.forEach((table) => {
        table.grantFullAccess(lambdaFunction)
        console.log(`Grant access to table - ${table}`)
    })

    buckets?.forEach((bucket) => {
        bucket.grantReadWrite(lambdaFunction)
        console.log(`Grant access to bucket - ${bucket}`)
    })

    if (eventSource) {
        lambdaFunction.addEventSource(eventSource)
        if (eventSource) console.log(`EventSource added`)
    }

    return lambdaFunction
}
