import { Stack, StackProps } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { IFunction } from 'aws-cdk-lib/aws-lambda';
import { StateMachine } from 'aws-cdk-lib/aws-stepfunctions';
import { DefinitionBody } from 'aws-cdk-lib/aws-stepfunctions';
import { fileURLToPath } from 'url';
import path, { dirname } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

export function concurrentFunctionStack(
    scope: Construct,
    id: string,
    props: StackProps & {
        processLambda: IFunction;
        data: object[];
    }
): StateMachine {
    const stack = new Stack(scope, id, props);

    const definition = DefinitionBody.fromFile(path.join(__dirname, 'stepfunction.asl.json'));

    const stateMachine = new StateMachine(stack, id, {
        definitionBody: definition,
        definitionSubstitutions: {
            ProcessFunctionArn: props.processLambda.functionArn,
            DataList: JSON.stringify(props.data),
        },
    });

    return stateMachine;
}