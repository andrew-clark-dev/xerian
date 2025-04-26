import { join } from 'path';

import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { NodejsFunction } from 'aws-cdk-lib/aws-lambda-nodejs';
import { Runtime } from 'aws-cdk-lib/aws-lambda';
import { AttributeType, Table } from 'aws-cdk-lib/aws-dynamodb';
import { Queue } from 'aws-cdk-lib/aws-sqs';
import { Rule, Schedule } from 'aws-cdk-lib/aws-events';
import { SfnStateMachine } from 'aws-cdk-lib/aws-events-targets';
import { LambdaInvoke } from 'aws-cdk-lib/aws-stepfunctions-tasks';
import { StateMachine } from 'aws-cdk-lib/aws-stepfunctions';

export class DataImportStack extends cdk.Stack {
    constructor(scope: Construct, id: string, props?: cdk.StackProps) {
        super(scope, id, props);

        // Create DynamoDB table for storing imported data
        const importTable = new Table(this, 'ImportedData', {
            partitionKey: { name: 'id', type: AttributeType.STRING },
        });

        // Create SQS Queue to hold the chunks of data
        const importQueue = new Queue(this, 'ImportQueue');

        // Lambda to fetch data from HTTP interface
        const fetchDataLambda = new NodejsFunction(this, 'FetchDataLambda', {
            entry: join(__dirname, '../functions/fetchData/handler.ts'),
            handler: 'handler', // Name of the exported function
            runtime: Runtime.NODEJS_20_X,
            environment: {
                DYNAMODB_TABLE: importTable.tableName,
                QUEUE_URL: importQueue.queueUrl,
            },
            bundling: {
                minify: true,
                sourceMap: true,
                target: 'es2022', // nice and modern
            }
        });

        // Lambda to process data and store in DynamoDB
        const processDataLambda = new NodejsFunction(this, 'ProcessDataLambda', {
            entry: join(__dirname, '../functions/processData/handler.ts'),
            handler: 'handler', // Name of the exported function
            runtime: Runtime.NODEJS_20_X,
            environment: {
                DYNAMODB_TABLE: importTable.tableName,
            },
            bundling: {
                minify: true,
                sourceMap: true,
                target: 'es2022', // nice and modern
            }
        });

        // Grant the Lambda functions access to the necessary resources
        importTable.grantReadWriteData(processDataLambda);
        importQueue.grantSendMessages(fetchDataLambda);
        importQueue.grantConsumeMessages(processDataLambda);

        // Step Function task to invoke Fetch Data Lambda
        const fetchDataTask = new LambdaInvoke(this, 'FetchData', {
            lambdaFunction: fetchDataLambda,
            resultPath: '$.fetchResult',
        });

        // Step Function task to invoke Process Data Lambda
        const processDataTask = new LambdaInvoke(this, 'ProcessData', {
            lambdaFunction: processDataLambda,
            resultPath: '$.processResult',
        });

        // Define Step Functions state machine
        const definition = fetchDataTask.next(processDataTask);

        const importStateMachine = new StateMachine(this, 'DataImportStateMachine', {
            definition,
        });

        // Trigger the Step Function periodically (for example, every hour)
        new Rule(this, 'TriggerImportRule', {
            schedule: Schedule.rate(cdk.Duration.hours(1)),
            targets: [new SfnStateMachine(importStateMachine)],
        });
    }
}
