import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { createActionFunction } from './data/create-action/resource';
import { importReceiveFunction, importItemFunction, IMPORT_DIRS } from './function/import/resource'; // 
import { truncateTableFunction } from './data/truncate-table/resource';
import { Effect, Policy, PolicyStatement } from 'aws-cdk-lib/aws-iam';
import { Stack } from 'aws-cdk-lib';
import { EventSourceMapping, StartingPosition } from 'aws-cdk-lib/aws-lambda';
import { initDataFunction } from './data/init-data/resource';
import { EventType } from 'aws-cdk-lib/aws-s3';
import { LambdaDestination } from 'aws-cdk-lib/aws-s3-notifications';
import { BucketDeployment, Source } from 'aws-cdk-lib/aws-s3-deployment';
import { createQueue } from './backend-helpers';
import { SqsEventSource } from 'aws-cdk-lib/aws-lambda-event-sources';
// import { createQueue } from './backend-sqs'
// import { SqsEventSource } from 'aws-cdk-lib/aws-lambda-event-sources';


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
// // const { region } = backend.stack
// // const { account } = backend.stack


const createActionLambda = backend.createActionFunction.resources.lambda
tables.Total.grantFullAccess(createActionLambda);

const createActionFunctionStreamingPolicy = new Policy(
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

createActionLambda.role?.attachInlinePolicy(createActionFunctionStreamingPolicy);
backend.createActionFunction.addEnvironment("TOTAL_TABLE_NAME", tables.Total.tableName);

// List of tables to create event source mappings for the createActionFunction
['Account', 'Item', 'Sale', 'Transaction', 'Comment'].forEach((f) => {
  const eventSourceMapping = new EventSourceMapping(
    Stack.of(tables[f]),
    `createAction${f}EventStreamMapping`,
    {
      target: createActionLambda,
      eventSourceArn: tables[f].tableStreamArn,
      startingPosition: StartingPosition.LATEST,
    }
  );
  eventSourceMapping.node.addDependency(createActionFunctionStreamingPolicy);
})

// Extend environment and add access to tables for backend functions
for (const key in tables) {
  const t = tables[key];
  [
    backend.truncateTableFunction,
    backend.initDataFunction,
    backend.importItemFunction
  ].forEach((f) => {
    f.addEnvironment(`${key.toUpperCase()}_TABLE`, t.tableName);
    t.grantFullAccess(f.resources.lambda);
  })
}

// Set up import storage and integrate with Lambda functions
// Preload a README file into S3 during deployment
const markdownContent = `
# Xerian import directory
Upload sync*.json files to the 'in' directory to import items in to the application.

Files content specifying the import period should be in JSON format, e.g.:
{
    "from": "2020-01-01T00:00:00.000Z",
    "to": "2020-02-01T00:00:00.000Z"
}
`;
new BucketDeployment(backend.stack, 'DeployImportReadme', {
  sources: [Source.data('README.md', markdownContent), Source.data('in/UPLOAD_IMPORT_FILES_HERE', "")],
  destinationBucket: bucket,
  destinationKeyPrefix: 'import/', // Creates import/README.md
});



const importReceiveLambda = backend.importReceiveFunction.resources.lambda;

bucket.addEventNotification(
  EventType.OBJECT_CREATED_PUT,
  new LambdaDestination(importReceiveLambda),
  { prefix: IMPORT_DIRS.IN_DIR + 'sync', suffix: '.json' }
);
backend.importReceiveFunction.addEnvironment(`NOTIFICATION_TABLE`, tables.Notification.tableName);
tables.Notification.grantFullAccess(importReceiveLambda);


const importItemLambda = backend.importItemFunction.resources.lambda;
const { queue: importQueue } = createQueue(backend.stack, { queueName: 'import' });
importItemLambda.addEventSource(new SqsEventSource(importQueue, { batchSize: 5 }));
importQueue.grantSendMessages(importReceiveLambda);








