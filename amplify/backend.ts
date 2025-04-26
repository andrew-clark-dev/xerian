import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { createActionFunction } from './data/create-action/resource';
import { importReceiveFunction, importItemFunction } from './function/import/resource'; // 
import { truncateTableFunction } from './data/truncate-table/resource';
import { Effect, Policy, PolicyStatement } from 'aws-cdk-lib/aws-iam';
import { Stack } from 'aws-cdk-lib';
import { EventSourceMapping, StartingPosition } from 'aws-cdk-lib/aws-lambda';
import { initDataFunction } from './data/init-data/resource';
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
  importItemFunction,
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
// const { region } = backend.stack
// const stackId = backend.stack.artifactId.split('-').pop();

const createActionLambda = backend.createActionFunction.resources.lambda
tables.Total.grantFullAccess(createActionLambda);

const createActionStreamingPolicy = new Policy(
  Stack.of(createActionLambda),
  "createActionStreamingPolicy",
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

createActionLambda.role?.attachInlinePolicy(createActionStreamingPolicy);
backend.createActionFunction.addEnvironment("TOTAL_TABLE", tables.Total.tableName);

// List of tables to create event source mappings for the createActionFunction
['Account', 'Item', 'Sale', 'Transaction', 'Comment'].forEach((tname) => {
  const eventSourceMapping = new EventSourceMapping(
    Stack.of(tables[tname]),
    `createAction${tname}EventStreamMapping`,
    {
      target: createActionLambda,
      eventSourceArn: tables[tname].tableStreamArn,
      startingPosition: StartingPosition.LATEST,
    }
  );
  eventSourceMapping.node.addDependency(createActionStreamingPolicy);
})

// Extend environment and add access to tables for backend functions
for (const key in tables) {
  const t = tables[key];
  [
    backend.truncateTableFunction,
    backend.initDataFunction,
    // backend.importItemFunction
  ].forEach((f) => {
    f.addEnvironment(`${key.toUpperCase()}_TABLE`, t.tableName);
    t.grantFullAccess(f.resources.lambda);
  })
}

// Set up import storage and integrate with Lambda functions
// Preload a README file into S3 during deployment
const markdownContent = `
# Xerian import directory
Upload sync-next.json file to this directory to initiate import items in to the application.

Files content specifying the import period should be in JSON format, e.g.:
{
    "from": "2020-01-01T00:00:00.000Z",
    "to": "2020-02-01T00:00:00.000Z"
}
`;
new BucketDeployment(backend.stack, 'DeployImportReadme', {
  sources: [Source.data('README.md', markdownContent)],
  destinationBucket: bucket,
  destinationKeyPrefix: 'import/', // Creates import/README.md
});

const importReceiveLambda = backend.importReceiveFunction.resources.lambda;

backend.importReceiveFunction.addEnvironment(`NOTIFICATION_TABLE`, tables.Notification.tableName);
backend.importReceiveFunction.addEnvironment(`IMPORTDATA_TABLE`, tables.ImportData.tableName);
tables.Notification.grantFullAccess(importReceiveLambda);
tables.ImportData.grantFullAccess(importReceiveLambda);

const importItemLambda = backend.importItemFunction.resources.lambda;

const importItemStreamingPolicy = new Policy(
  Stack.of(importItemLambda),
  "importItemStreamingPolicy",
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
importItemLambda.role?.attachInlinePolicy(importItemStreamingPolicy);


const importItemEventSourceMapping = new EventSourceMapping(
  Stack.of(tables.ImportData),
  `importItemImportDataEventStreamMapping`,
  {
    target: importItemLambda,
    eventSourceArn: tables.ImportData.tableStreamArn,
    startingPosition: StartingPosition.LATEST,
  }
);
importItemEventSourceMapping.node.addDependency(importItemStreamingPolicy);


// Tables that import has to write to
['Account', 'Item', 'Sale', 'Transaction', 'UserProfile', 'ItemGroup', 'ItemCategory', 'Notification'].forEach((tname) => {
  const t = tables[tname];
  [
    backend.importItemFunction
  ].forEach((f) => {
    f.addEnvironment(`${tname.toUpperCase()}_TABLE`, t.tableName);
    t.grantFullAccess(f.resources.lambda);
  })
}
)