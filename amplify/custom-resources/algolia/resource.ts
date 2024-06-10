import { Duration, Stack } from 'aws-cdk-lib';
import * as path from "path";

import { Architecture, Code, LayerVersion, Runtime, Function } from "aws-cdk-lib/aws-lambda";

import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export function algoliaSearchInjest(stack: Stack): void {
    // Creating the Lambda Layer
    const algoliaLayer = new LayerVersion(stack, 'AlgoliaLayer', {
        compatibleRuntimes: [Runtime.PYTHON_3_12],
        compatibleArchitectures: [Architecture.X86_64],
        code: Code.fromDockerBuild(path.join(__dirname, 'docker'))
    })

    const lambdaFunction = new Function(
        stack,
        `algolia-injest-function`,
        {
            runtime: Runtime.PYTHON_3_12,
            code: Code.fromAsset(`./amplify/custom-resources/algolia/`),
            handler: 'function.handler',
            timeout: Duration.seconds(900),
            memorySize: 1024,
            layers: [algoliaLayer],
        })

}