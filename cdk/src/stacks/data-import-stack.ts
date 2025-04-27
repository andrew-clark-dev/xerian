import { Stack, StackProps, RemovalPolicy, Duration } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { Runtime } from 'aws-cdk-lib/aws-lambda';
import { Table, AttributeType, BillingMode } from 'aws-cdk-lib/aws-dynamodb';
import { StateMachine, Choice, Succeed, Pass, Condition, TaskInput, LogLevel, DefinitionBody } from 'aws-cdk-lib/aws-stepfunctions';
import { LambdaInvoke } from 'aws-cdk-lib/aws-stepfunctions-tasks';
import { PolicyStatement, Role, ServicePrincipal } from 'aws-cdk-lib/aws-iam';
import * as path from 'path';
import { NodejsFunction } from 'aws-cdk-lib/aws-lambda-nodejs';
import { LogGroup } from 'aws-cdk-lib/aws-logs';

export class DataImportStack extends Stack {
    constructor(scope: Construct, id: string, props?: StackProps) {
        super(scope, id, props);

        // 1. DynamoDB Table for Import
        const stage = this.node.tryGetContext('stage') || 'dev'; // Default to 'dev' if no stage is provided
        const tableDisc = this.node.tryGetContext('table_disc')
        const apiKey = this.node.tryGetContext('api_key')

        const importTableName = `ImportTable-${stage}`;

        const importTable = new Table(this, 'ImportTable', {
            partitionKey: { name: 'id', type: AttributeType.STRING },
            sortKey: { name: 'createdAt', type: AttributeType.STRING },
            tableName: importTableName,
            removalPolicy: RemovalPolicy.DESTROY, // only for dev/test, not production
            billingMode: BillingMode.PAY_PER_REQUEST, // On-demand mode
        });

        // 2. Lambda Function for Fetching Data
        const fetchDataFunction = new NodejsFunction(this, 'FetchDataLambda', {
            entry: path.join(__dirname, '../functions/fetch-data/handler.ts'),
            handler: 'handler',
            runtime: Runtime.NODEJS_20_X,
            memorySize: 1024,
            timeout: Duration.minutes(10),
            environment: {
                DYNAMODB_TABLE: importTable.tableName,
                TABLE_DISC: tableDisc,
                API_KEY: apiKey,
            },
            bundling: {
                minify: true,
                sourceMap: true,
                target: 'es2022', // nice and modern
            }
        });

        // Grant the Fetch Function permissions to write to DynamoDB
        importTable.grantWriteData(fetchDataFunction);

        // 3. Step Function Task to Invoke the Fetch Function
        const fetchDataTask = new LambdaInvoke(this, 'Fetch Data', {
            lambdaFunction: fetchDataFunction,
            payload: TaskInput.fromObject({
                from: "2020-01-01T00:00:00.000Z",
                to: "2020-02-01T00:00:00.000Z",
            }),
            outputPath: '$.Payload',
        });

        // 4. Step Function Task to Update the Date Range
        const updateDateRangeTask = new Pass(this, 'Update Date Range', {
            parameters: {
                'from.$': '$.from',   // Pass the updated 'from' date
                'to.$': '$.to',       // Pass the updated 'to' date
                'hasMorePages.$': '$.hasMorePages',  // Pass hasMorePages
            },
        });

        // 5. Step Function Choice State to Handle More Pages
        const isMorePages = new Choice(this, 'More Pages?');

        // 6. Step Function Succeed State when Finished
        const finishedState = new Succeed(this, 'Import Finished');

        // 7. Defining the Step Function Workflow
        const definition = fetchDataTask
            .next(updateDateRangeTask)
            .next(
                isMorePages
                    .when(Condition.booleanEquals('$.hasMorePages', true), fetchDataTask)  // Correctly checking if more pages exist
                    .otherwise(finishedState) // Finish when no more pages
            );

        // 8. Step Function
        const dataImportStateMachine = new StateMachine(this, 'DataImportStateMachine', {
            definitionBody: DefinitionBody.fromChainable(definition),
            stateMachineName: 'DataImportStateMachine',
            logs: {
                destination: new LogGroup(this, 'DataImportStateMachineLogs', {
                    logGroupName: '/aws/vendedlogs/states/DataImportStateMachine',
                    removalPolicy: RemovalPolicy.DESTROY,
                }),
                level: LogLevel.ALL,
                includeExecutionData: true,
            }
        });

        // 9. Step Function Role (optional if you need custom permissions)
        const stepFunctionRole = new Role(this, 'StepFunctionRole', {
            assumedBy: new ServicePrincipal('states.amazonaws.com'),
        });

        // Add permissions for CloudWatch Logs via inline policy
        stepFunctionRole.addToPolicy(
            new PolicyStatement({
                actions: ['logs:CreateLogStream', 'logs:PutLogEvents'],
                resources: ['arn:aws:logs:*:*:*'], // Allow logging to any CloudWatch log stream
            })
        );

        // Optional: Grant Step Function permissions (if needed)
        dataImportStateMachine.grantStartExecution(stepFunctionRole);
    }
}
