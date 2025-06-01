import { Stack, StackProps } from 'aws-cdk-lib';
import { IBucket } from 'aws-cdk-lib/aws-s3';
import { Construct } from 'constructs';
import { Function, IFunction } from 'aws-cdk-lib/aws-lambda';
import { StateMachine } from 'aws-cdk-lib/aws-stepfunctions';
import { DefinitionBody } from 'aws-cdk-lib/aws-stepfunctions';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { fileURLToPath } from 'url';
import path, { dirname } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

export function loopStepFunctionStack(
    scope: Construct,
    id: string,
    props: StackProps & {
        fetchLambda: IFunction;
        processLambda: IFunction;
        targetTable: ITable;
        bucket: IBucket;
    }
): StateMachine {
    const stack = new Stack(scope, id, props);

    props.bucket.grantReadWrite(props.fetchLambda);
    props.bucket.grantReadWrite(props.processLambda);

    props.targetTable.grantWriteData(props.processLambda);
    props.targetTable.grantWriteData(props.processLambda);
    (props.fetchLambda as Function).addEnvironment('BUCKET_NAME', props.bucket.bucketName);
    (props.processLambda as Function).addEnvironment('BUCKET_NAME', props.bucket.bucketName);
    (props.processLambda as Function).addEnvironment('TARGET_TABLE_NAME', props.targetTable.tableName);

    const definition = DefinitionBody.fromFile(path.join(__dirname, 'stepfunction.asl.json'));

    const stateMachine = new StateMachine(stack, 'LoopStepFunction', {
        definitionBody: definition,
        definitionSubstitutions: {
            FetchFunctionArn: props.fetchLambda.functionArn,
            ProcessFunctionArn: props.processLambda.functionArn,
        },
    });

    return stateMachine;
}