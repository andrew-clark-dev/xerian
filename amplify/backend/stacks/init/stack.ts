import { Stack, StackProps } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { IFunction } from 'aws-cdk-lib/aws-lambda';
import { StateMachine } from 'aws-cdk-lib/aws-stepfunctions';
import { DefinitionBody } from 'aws-cdk-lib/aws-stepfunctions';
import { fileURLToPath } from 'url';
import path, { dirname } from 'path';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';

const __dirname = dirname(fileURLToPath(import.meta.url));

interface InitStackProps extends StackProps {
    provisionUsers: IFunction,
    truncate: IFunction,
    tables: Record<string, ITable>
}

export function createInit(
    scope: Construct,
    id: string,
    props: InitStackProps,
): StateMachine {
    const stack = new Stack(scope, id, props);

    const definition = DefinitionBody.fromFile(path.join(__dirname, 'stepfunction.asl.json'));

    const stateMachine = new StateMachine(stack, id, {
        definitionBody: definition,
        definitionSubstitutions: {
            ProvisionUsersArn: props.provisionUsers.functionArn,
            TruncateArn: props.truncate.functionArn,
        },
    });

    return stateMachine;
}