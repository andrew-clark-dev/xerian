import { Stack, StackProps, RemovalPolicy } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { Runtime } from 'aws-cdk-lib/aws-lambda';
import { Table, AttributeType } from 'aws-cdk-lib/aws-dynamodb';
import { StateMachine, Choice, Succeed, Pass, Condition, TaskInput } from 'aws-cdk-lib/aws-stepfunctions';
import { LambdaInvoke } from 'aws-cdk-lib/aws-stepfunctions-tasks';
import { Role, ServicePrincipal } from 'aws-cdk-lib/aws-iam';
import * as path from 'path';
import { NodejsFunction } from 'aws-cdk-lib/aws-lambda-nodejs';

export class DataImportStack extends Stack {
    constructor(scope: Construct, id: string, props?: StackProps) {
        super(scope, id, props);

        // 1. DynamoDB Table for Import
        // Get the stage from the environment or context
        const stage = this.node.tryGetContext('stage') || 'dev'; // Default to 'dev' if no stage is provided

        // Create a unique table name based on the stage
        const importTableName = `ImportTable-${stage}`;

        const importTable = new Table(this, 'ImportTable', {
            partitionKey: { name: 'id', type: AttributeType.STRING },
            tableName: importTableName,
            removalPolicy: RemovalPolicy.DESTROY, // only for dev/test, not production
        });

        // 2. Lambda Function for Fetching Data
        // Lambda to fetch data from HTTP interface
        const fetchDataFunction = new NodejsFunction(this, 'FetchDataLambda', {
            entry: path.join(__dirname, '../functions/fetch-data/handler.ts'),
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

        // Grant the Fetch Function permissions to write to DynamoDB
        importTable.grantWriteData(fetchDataFunction);

        // // 3. Lambda Function for Processing Data (Processing logic is not detailed)
        // const processDataFunction = new Function(this, 'ProcessDataFunction', {
        //     runtime: Runtime.NODEJS_22_X, 
        //     handler: 'index.handler',
        //     code: Code.fromAsset(path.join(__dirname, 'lambda-functions/processDataFunction')),
        //     environment: {
        //         IMPORT_TABLE_NAME: importTable.tableName,
        //     },
        // });

        // // Grant the Process Function permissions to read from DynamoDB
        // importTable.grantReadData(processDataFunction);

        // 4. Step Function Task to Invoke the Fetch Function
        const fetchDataTask = new LambdaInvoke(this, 'Fetch Data', {
            lambdaFunction: fetchDataFunction,
            payload: TaskInput.fromObject({
                cursor: TaskInput.fromJsonPathAt('$.cursor'), // Correct method to reference the cursor dynamically
            }),
            outputPath: '$.Payload',
        });

        // 5. Step Function Task to Update the Cursor
        const updateCursorTask = new Pass(this, 'Update Cursor', {
            parameters: {
                'cursor.$': '$.nextCursor',  // pass the next cursor for pagination
                'hasMore.$': '$.hasMore',    // check if there are more pages
            },
        });

        // 6. Step Function Choice State to Handle More Pages
        const isMorePages = new Choice(this, 'More Pages?');

        // 7. Step Function Succeed State when Finished
        const finishedState = new Succeed(this, 'Import Finished');

        // 8. Defining the Step Function Workflow
        const definition = fetchDataTask
            .next(updateCursorTask)
            .next(
                isMorePages
                    .when(Condition.booleanEquals('$.hasMore', true), fetchDataTask)  // Correctly checking boolean
                    .otherwise(finishedState) // Finish when no more pages
            );

        // 9. Step Function
        const dataImportStateMachine = new StateMachine(this, 'DataImportStateMachine', {
            definition,
            stateMachineName: 'DataImportStateMachine',
        });

        // 10. Step Function Role (optional if you need custom permissions)
        const stepFunctionRole = new Role(this, 'StepFunctionRole', {
            assumedBy: new ServicePrincipal('states.amazonaws.com'),
        });

        // Optional: Grant Step Function permissions (if needed)
        dataImportStateMachine.grantStartExecution(stepFunctionRole);
    }
}
