import { Stack, StackProps } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { IFunction } from 'aws-cdk-lib/aws-lambda';
import { Role, ServicePrincipal, ManagedPolicy } from 'aws-cdk-lib/aws-iam';
import { CfnStateMachine } from 'aws-cdk-lib/aws-stepfunctions';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import Mustache from 'mustache';

/* Initial data for the fetch-data step function
  {
    "from": "2020-01-01T00:00:00.000Z",
    "to": "2020-02-01T00:00:00.000Z"
}
 */


const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

interface FetchDataStackProps extends StackProps {
    fetchDataLambda: IFunction
}

export class FetchDataStepFunctionStack extends Stack {
    constructor(scope: Construct, id: string, props: FetchDataStackProps) {
        super(scope, id, props);

        const role = new Role(this, 'StepFunctionExecutionRole', {
            assumedBy: new ServicePrincipal('states.amazonaws.com'),
            managedPolicies: [
                ManagedPolicy.fromAwsManagedPolicyName('service-role/AWSLambdaRole'),
            ],
        });

        const aslPath = join(__dirname, './assets/fetch-data.asl.json');
        const aslTemplate = readFileSync(aslPath, 'utf8');

        const renderedDefinition = Mustache.render(aslTemplate, {
            lambdaArn: props.fetchDataLambda.functionArn,
        });

        new CfnStateMachine(this, 'FetchDataStateMachine', {
            definitionString: renderedDefinition,
            roleArn: role.roleArn,
        });

        props.fetchDataLambda.grantInvoke(role);
    }
}
