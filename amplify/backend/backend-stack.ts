import { streamDbToLambdaStack } from "./stacks/stream-db-to-lambda/stack";
import { Construct } from "constructs";
import { ITable } from "aws-cdk-lib/aws-dynamodb";
import { IFunction } from "aws-cdk-lib/aws-lambda";
import { IBucket } from "aws-cdk-lib/aws-s3";
import { loopStepFunctionStack } from "./stacks/loop-stepfunction/stack";
import { createPythonLambda } from './stacks/python-service/stack';
import { fileURLToPath } from 'url';
import path, { dirname } from 'path';
import { IUserPool } from "aws-cdk-lib/aws-cognito";

const __dirname = dirname(fileURLToPath(import.meta.url));

interface AmplifyAuth {
    resources: {
        userPool: IUserPool;
    };
}
interface AmplifyFunction {
    resources: {
        lambda: IFunction;
    };
}


interface AmplifyContructs {
    stack: Construct;
    dataStack: Construct;
    auth: AmplifyAuth;
    tables: Record<string, ITable>
    bucket: IBucket;
    functions: Record<string, AmplifyFunction>;
}

export function backendStack(backend: AmplifyContructs) {

    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const truncateLambda = createPythonLambda(backend.stack, 'TruncatePythonLambda', {
        lambdaId: 'TruncatePythonLambda',
        entryPath: path.join(__dirname, './src/truncate'),
        handler: 'handler.lambda_handler',
        tables: backend.tables,
    });


    const onChangeLambda = createPythonLambda(backend.stack, 'OnChangePythonLambda', {
        lambdaId: 'OnChangePythonLambda',
        entryPath: path.join(__dirname, './src/on-change'),
        handler: 'handler.lambda_handler',
        tables: {
            Action: backend.tables.Action,
            Total: backend.tables.Total,
        },
    });

    streamDbToLambdaStack(backend.dataStack, 'accountAction', {
        lambda: onChangeLambda,
        sourceTables: [
            backend.tables.Account,
            backend.tables.Item,
            backend.tables.Sale,
            backend.tables.Transaction,
            backend.tables.Comment
        ]  // Pass thetablex to be tracked
    });

    loopStepFunctionStack(backend.stack, 'ItemImportFunction', {
        fetchLambda: backend.functions.fetchItemFunction.resources.lambda,
        processLambda: backend.functions.processItemFunction.resources.lambda,
        targetTable: backend.tables.Item,
        bucket: backend.bucket,
    });


}