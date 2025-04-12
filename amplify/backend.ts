import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { createActionFunction } from './data/create-action/resource';
import { importReceiveFunction, importAccountFunction, importItemFunction, importSaleFunction, IMPORT_DIRS } from './data/import/resource';
import { truncateTableFunction } from './data/truncate-table/resource';
import { Effect, Policy, PolicyStatement } from 'aws-cdk-lib/aws-iam';
import { Stack } from 'aws-cdk-lib';
import { EventSourceMapping, StartingPosition } from 'aws-cdk-lib/aws-lambda';
import { initDataFunction } from './data/init-data/resource';
import { EventType } from 'aws-cdk-lib/aws-s3';
import { LambdaDestination } from 'aws-cdk-lib/aws-s3-notifications';
import { BucketDeployment, Source } from 'aws-cdk-lib/aws-s3-deployment';


/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  storage,
  truncateTableFunction,
  initDataFunction,
  createActionFunction,
  importReceiveFunction,
  importAccountFunction,
  importItemFunction,
  importSaleFunction,
});


// extract L1 CfnUserPool resources
const { cfnUserPool } = backend.auth.resources.cfnResources;
// modify cfnUserPool policies directly
cfnUserPool.policies = {
  passwordPolicy: {
    minimumLength: 20,
    requireLowercase: false,
    requireNumbers: true,
    requireSymbols: false,
    requireUppercase: false,
    temporaryPasswordValidityDays: 20,
  },
};


const { tables } = backend.data.resources
const { bucket } = backend.storage.resources

// const region = backend.stack.region
// const accountId = backend.stack.account


const createActionLambda = backend.createActionFunction.resources.lambda
tables.Total.grantFullAccess(createActionLambda);

const policy = new Policy(
  Stack.of(createActionLambda),
  "createActionFunctionStreamingPolicy",
  {
    statements: [
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams",
        ],
        resources: ["*"],
      }),
    ],
  }
);

createActionLambda.role?.attachInlinePolicy(policy);
backend.createActionFunction.addEnvironment("TOTAL_TABLE_NAME", tables.Total.tableName);

const accountMapping = new EventSourceMapping(
  Stack.of(tables["Account"]),
  "createActionAccountEventStreamMapping",
  {
    target: createActionLambda,
    eventSourceArn: tables["Account"].tableStreamArn,
    startingPosition: StartingPosition.LATEST,
  }
);

accountMapping.node.addDependency(policy);

const itemMapping = new EventSourceMapping(
  Stack.of(tables["Item"]),
  "createActionItemEventStreamMapping",
  {
    target: createActionLambda,
    eventSourceArn: tables["Item"].tableStreamArn,
    startingPosition: StartingPosition.LATEST,
  }
);

itemMapping.node.addDependency(policy);

const saleMapping = new EventSourceMapping(
  Stack.of(tables["Sale"]),
  "createActionSaleEventStreamMapping",
  {
    target: createActionLambda,
    eventSourceArn: tables["Sale"].tableStreamArn,
    startingPosition: StartingPosition.LATEST,
  }
);

saleMapping.node.addDependency(policy);

const transactionMapping = new EventSourceMapping(
  Stack.of(tables["Transaction"]),
  "createActionTransactionEventStreamMapping",
  {
    target: createActionLambda,
    eventSourceArn: tables["Transaction"].tableStreamArn,
    startingPosition: StartingPosition.LATEST,
  }
);

transactionMapping.node.addDependency(policy);

const commentMapping = new EventSourceMapping(
  Stack.of(tables["Comment"]),
  "createActionCommentEventStreamMapping",
  {
    target: createActionLambda,
    eventSourceArn: tables["Comment"].tableStreamArn,
    startingPosition: StartingPosition.LATEST,
  }
);

commentMapping.node.addDependency(policy);


// Extend add environment and access for table functions
for (const key in tables) {
  const t = tables[key];
  backend.truncateTableFunction.addEnvironment(`${key.toUpperCase()}_TABLE`, t.tableName)
  backend.initDataFunction.addEnvironment(`${key.toUpperCase()}_TABLE`, t.tableName)
  t.grantFullAccess(backend.truncateTableFunction.resources.lambda);
  t.grantFullAccess(backend.initDataFunction.resources.lambda);
}

// Set up import storage and integrate with Lambda functions
// Preload a README file into S3 during deployment
// Define a Markdown file content
const markdownContent = `# Xerian import directory

Upload .csv files to the 'in' directory to import objects in to the application.

## Supported objects
- Account (Account*.csv)
- Item (Item*.csv)
- Sale (Sale*.csv)`;

new BucketDeployment(backend.stack, 'DeployImportReadme', {
  sources: [Source.data('README.md', markdownContent), Source.data('in/UPLOAD_IMPORT_FILES_HERE', "")],
  destinationBucket: bucket,
  destinationKeyPrefix: 'import/', // Creates import/README.md
});

const importAccountLambda = backend.importAccountFunction.resources.lambda;
const importItemLambda = backend.importItemFunction.resources.lambda;
const importReceiveLambda = backend.importReceiveFunction.resources.lambda;
const importSaleLambda = backend.importSaleFunction.resources.lambda;

bucket.addEventNotification(
  EventType.OBJECT_CREATED_PUT,
  new LambdaDestination(importReceiveLambda),
  { prefix: IMPORT_DIRS.IN_DIR + 'Sync', suffix: '.json' }
);

bucket.addEventNotification(
  EventType.OBJECT_CREATED_PUT,
  new LambdaDestination(importAccountLambda),
  { prefix: IMPORT_DIRS.PROCESSING_DIR + 'Account', suffix: '.csv' }
);

bucket.addEventNotification(
  EventType.OBJECT_CREATED_PUT,
  new LambdaDestination(importItemLambda),
  { prefix: IMPORT_DIRS.PROCESSING_DIR + 'Item', suffix: '.csv' }
);

bucket.addEventNotification(
  EventType.OBJECT_CREATED_PUT,
  new LambdaDestination(importSaleLambda),
  { prefix: IMPORT_DIRS.PROCESSING_DIR + 'Sale', suffix: '.csv' }
);

