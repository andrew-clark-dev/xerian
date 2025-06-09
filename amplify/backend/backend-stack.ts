import { createStreamDbToLambda } from "./stacks/components/stream-db-to-lambda/stack";
import { Construct } from "constructs";
import { ITable } from "aws-cdk-lib/aws-dynamodb";
import { IFunction } from "aws-cdk-lib/aws-lambda";
import { IBucket } from "aws-cdk-lib/aws-s3";
import { createLoopStepFunction } from "./stacks/components/loop-stepfunction/stack";
import { createPythonLambda } from './stacks/components/python-service/stack';
import { fileURLToPath } from 'url';
import path, { dirname } from 'path';
import { IUserPool } from "aws-cdk-lib/aws-cognito";
import { createInit } from "./stacks/init/stack";

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
    addEnvironment: (key: string, value: string) => void;
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

    grantAccess(backend.functions.provisionUserFunction, [backend.tables.UserProfile])


    const onChangeLambda = createPythonLambda(backend.stack, 'OnChangePythonLambda', {
        lambdaId: 'OnChangePythonLambda',
        entryPath: path.join(__dirname, './src/on-change'),
        handler: 'handler.lambda_handler',
        tables: {
            Action: backend.tables.Action,
            Total: backend.tables.Total,
        },
    });

    createStreamDbToLambda(backend.dataStack, 'accountAction', {
        lambda: onChangeLambda,
        sourceTables: [
            backend.tables.Account,
            backend.tables.Item,
            backend.tables.Sale,
            backend.tables.Transaction,
            backend.tables.Comment
        ]  // Pass thetablex to be tracked
    });

    createLoopStepFunction(backend.stack, 'ItemImportFunction', {
        fetchLambda: backend.functions.fetchItemFunction.resources.lambda,
        processLambda: backend.functions.processItemFunction.resources.lambda,
        targetTable: backend.tables.Item,
        bucket: backend.bucket,
    });

    const truncateLambda = createPythonLambda(backend.stack, 'TruncatePythonLambda', {
        lambdaId: 'TruncatePythonLambda',
        entryPath: path.join(__dirname, './src/truncate'),
        handler: 'handler.lambda_handler',
        tables: backend.tables,
    });

    createInit(backend.stack, 'InitializePythonLambda', {
        provisionUsers: backend.functions.provisionUserFunction.resources.lambda,
        truncate: truncateLambda,
        tables: backend.tables,
    });
}


// ----------------------------------------------------
// -- Grant access to tables for backend 


function grantAccess(backendFunction: AmplifyFunction, tables: ITable[]) {
    tables.forEach((table) => {
        // table.grantFullAccess(backendFunction.resources.lambda);
        // backendFunction.addEnvironment(table.tableName.toUpperCase() + '_TABLE', table.tableName);
    })
}