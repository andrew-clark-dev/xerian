import { Construct } from 'constructs';
import { StackProps, Duration } from 'aws-cdk-lib';
import { Function, Runtime, Code } from 'aws-cdk-lib/aws-lambda';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';

interface PythonLambdaStackProps extends StackProps {
    lambdaId: string;
    entryPath: string; // relative path to the Python source directory
    handler: string;   // e.g., 'app.lambda_handler'
    timeoutSecs?: number;
    environment?: Record<string, string>;
    tables: Record<string, ITable>
}

export function createPythonLambda(scope: Construct, id: string, props: PythonLambdaStackProps): Function {
    const lambda = new Function(scope, props.lambdaId, {
        runtime: Runtime.PYTHON_3_12,
        handler: props.handler,
        code: Code.fromAsset(props.entryPath),
        timeout: Duration.seconds(props.timeoutSecs ?? 30),
        environment: props.environment,
    });
    Object.entries(props.tables).forEach(([key, table]) => {
        table.grantFullAccess(lambda);
        lambda.addEnvironment(`${key.toUpperCase()}_TABLE_NAME`, table.tableName);
    });
    return lambda;
}