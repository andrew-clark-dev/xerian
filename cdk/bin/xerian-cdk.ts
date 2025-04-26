import * as cdk from 'aws-cdk-lib';
import { DataImportStack } from '../src/stacks/data-import-stack';

const app = new cdk.App();
new DataImportStack(app, 'DataImportStack');
