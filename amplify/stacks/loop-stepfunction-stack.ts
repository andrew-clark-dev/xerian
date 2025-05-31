import { Stack, StackProps } from 'aws-cdk-lib';
import { Bucket } from 'aws-cdk-lib/aws-s3';
import { RemovalPolicy } from 'aws-cdk-lib';
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
    }
): StateMachine {
    const stack = new Stack(scope, id, props);

    const fetchLambdaName = Stack.of(stack).resolve(props.fetchLambda.functionName).toString();
    const bucketName = `${Stack.of(stack).stackName.toLowerCase()}-${fetchLambdaName.toLowerCase()}-temp`
        .replace(/[^a-z0-9-]/g, '')
        .substring(0, 63);

    const tempBucket = new Bucket(stack, 'TempStorageBucket', {
        bucketName,
        removalPolicy: RemovalPolicy.DESTROY,
        autoDeleteObjects: true,
        lifecycleRules: [
            {
                prefix: 'archive/',
                enabled: true,
            },
        ],
    });

    tempBucket.grantReadWrite(props.fetchLambda);
    tempBucket.grantReadWrite(props.processLambda);

    props.targetTable.grantWriteData(props.processLambda);
    props.targetTable.grantWriteData(props.processLambda);
    (props.fetchLambda as Function).addEnvironment('TEMP_BUCKET_NAME', tempBucket.bucketName);
    (props.processLambda as Function).addEnvironment('TEMP_BUCKET_NAME', tempBucket.bucketName);
    (props.processLambda as Function).addEnvironment('TARGET_TABLE_NAME', props.targetTable.tableName);

    const definition = DefinitionBody.fromFile(path.join(__dirname, 'loop-stepfunction-stack.asl.json'));

    const stateMachine = new StateMachine(stack, 'LoopStepFunction', {
        definitionBody: definition,
        definitionSubstitutions: {
            FetchFunctionArn: props.fetchLambda.functionArn,
            ProcessFunctionArn: props.processLambda.functionArn,
        },
    });

    return stateMachine;
}