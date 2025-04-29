import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { createActionFunction } from './data/create-action/resource';
import { importFetchFunction, importItemFunction } from './function/import/resource'; // 
import { Effect, Policy, PolicyStatement } from 'aws-cdk-lib/aws-iam';
import { Stack } from 'aws-cdk-lib';
import { EventSourceMapping, StartingPosition } from 'aws-cdk-lib/aws-lambda';
import { FetchDataStack } from './backend/stacks/fetch-data-stack';
import { initDataFunction, truncateTableFunction } from './function/utils/resource';


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
  importFetchFunction,
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
// const { bucket } = backend.storage.resources
// const { region } = backend.stack
// const stackId = backend.stack.artifactId.split('-').pop();
// const amplifyBranch = process.env.AMPLIFY_BRANCH ?? 'dev';




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



const importFetchLambda = backend.importFetchFunction.resources.lambda;

backend.importFetchFunction.addEnvironment(`NOTIFICATION_TABLE`, tables.Notification.tableName);
backend.importFetchFunction.addEnvironment(`IMPORTDATA_TABLE`, tables.ImportData.tableName);
tables.Notification.grantFullAccess(importFetchLambda);
tables.ImportData.grantFullAccess(importFetchLambda);


const customStack = backend.createStack('CustomStack')

new FetchDataStack(customStack, 'FetchDataStack', { fetchDataFunction: backend.importFetchFunction.resources.lambda });



// // Tables that import has to write to
// ['Account', 'Item', 'Sale', 'Transaction', 'UserProfile', 'ItemGroup', 'ItemCategory', 'Notification'].forEach((tname) => {
//   const t = tables[tname];
//   [
//     backend.importItemFunction
//   ].forEach((f) => {
//     f.addEnvironment(`${tname.toUpperCase()}_TABLE`, t.tableName);
//     t.grantFullAccess(f.resources.lambda);
//   })
// }
// )
