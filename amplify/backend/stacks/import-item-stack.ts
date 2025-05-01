import { Stack, StackProps } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as sfn from 'aws-cdk-lib/aws-stepfunctions';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as fs from 'fs';
import * as path from 'path';
import mustache from 'mustache';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);


interface ImportItemStackProps extends StackProps {
    importItemLambda: lambda.IFunction;
}

export class ImportItemStepFunctionStack extends Stack {
    constructor(scope: Construct, id: string, props: ImportItemStackProps) {
        super(scope, id, props);

        // Load and render ASL template
        const aslPath = path.join(__dirname, './assets/import-data.asl.json');
        const template = fs.readFileSync(aslPath, 'utf-8');
        const definition = mustache.render(template, {
            lambdaArn: props.importItemLambda.functionArn,
        });

        // Deploy the Step Function
        const stateMachineRole = new iam.Role(this, 'StateMachineRole', {
            assumedBy: new iam.ServicePrincipal('states.amazonaws.com'),
        });

        // Grant permission to invoke the Lambda
        props.importItemLambda.grantInvoke(stateMachineRole);

        new sfn.CfnStateMachine(this, 'ImportItemStateMachine', {
            definitionString: definition,
            roleArn: stateMachineRole.roleArn,
            stateMachineType: 'STANDARD',
        });
    }
}
