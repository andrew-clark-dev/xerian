import { streamDbToLambdaStack } from "./stacks/stream-db-to-lambda/stack";
import { Construct } from "constructs";
import { ITable } from "aws-cdk-lib/aws-dynamodb";
import { IFunction } from "aws-cdk-lib/aws-lambda";
import { IBucket } from "aws-cdk-lib/aws-s3";
import { loopStepFunctionStack } from "./stacks/loop-stepfunction/stack";

interface AmplifyFunction {
    resources: {
        lambda: IFunction;
    };

}

interface AmplifyContructs {
    stack: Construct;
    dataStack: Construct;
    tables: Record<string, ITable>
    bucket: IBucket;
    functions: Record<string, AmplifyFunction>;
}

export function backendStack(backend: AmplifyContructs) {

    streamDbToLambdaStack(backend.dataStack, 'accountAction', {
        lambda: backend.functions.createActionFunction.resources.lambda,
        sourceTables: [
            backend.tables.Account,
            backend.tables.Item,
            backend.tables.Sale,
            backend.tables.Transaction,
            backend.tables.Comment
        ],   // Pass thetablex to be tracked
        targetTable: backend.tables.Action      // Pass the Action table as a named property
    });

    loopStepFunctionStack(backend.stack, 'ItemImportFunction', {
        fetchLambda: backend.functions.fetchItemFunction.resources.lambda,
        processLambda: backend.functions.processItemFunction.resources.lambda,
        targetTable: backend.tables.Item,
        bucket: backend.bucket,
    });


}