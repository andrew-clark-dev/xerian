import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
// import { loopStepFunctionStack } from './stacks/loop-stepfunction-stack';
// import { fetchItemFunction, processItemFunction } from './function/import/resource'; // 
// import { Effect, Policy, PolicyStatement } from 'aws-cdk-lib/aws-iam';
// import { Stack } from 'aws-cdk-lib';
// import { EventSourceMapping, StartingPosition } from 'aws-cdk-lib/aws-lambda';
import { initDataFunction, truncateTableFunction } from './function/utils/resource';
import { createActionFunction } from './function/create-action/resource';

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
  // fetchItemFunction,
  // processItemFunction,
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


// const { tables } = backend.data.resources
// // const { bucket } = backend.storage.resources
// // const { region } = backend.stack
// // const stackId = backend.stack.artifactId.split('-').pop();
// // const amplifyBranch = process.env.AMPLIFY_BRANCH ?? 'dev';

// const createActionLambda = backend.createActionFunction.resources.lambda
// tables.Total.grantFullAccess(createActionLambda);
// backend.createActionFunction.addEnvironment("TOTAL_TABLE", tables.Total.tableName);
// tables.Notification.grantFullAccess(createActionLambda);
// backend.createActionFunction.addEnvironment("NOTIFICATION_TABLE", tables.Notification.tableName);
// tables.Action.grantFullAccess(createActionLambda);
// backend.createActionFunction.addEnvironment("ACTION_TABLE", tables.Action.tableName);

// const streamingPolicy = new Policy(
//   backend.stack,
//   "createActionStreamingPolicy",
//   {
//     statements: [
//       new PolicyStatement({
//         effect: Effect.ALLOW,
//         actions: [
//           "dynamodb:DescribeStream",
//           "dynamodb:GetRecords",
//           "dynamodb:GetShardIterator",
//           "dynamodb:ListStreams",
//         ],
//         resources: ["*"],
//       }),
//     ],
//   }
// );

// createActionLambda.role?.attachInlinePolicy(streamingPolicy);

// // List of tables to create event source mappings for the createActionFunction
// ['Account', 'Item', 'Sale', 'Transaction', 'Comment'].forEach((tname) => {
//   const eventSourceMapping = new EventSourceMapping(
//     Stack.of(tables[tname]),
//     `createAction${tname}EventStreamMapping`,
//     {
//       target: createActionLambda,
//       eventSourceArn: tables[tname].tableStreamArn,
//       startingPosition: StartingPosition.LATEST,
//       batchSize: 100,
//       enabled: true,
//     }
//   );
//   eventSourceMapping.node.addDependency(streamingPolicy);
// })

// // Extend environment and add access to tables for backend functions
// for (const key in tables) {
//   const t = tables[key];
//   [
//     backend.truncateTableFunction,
//     backend.initDataFunction,
//   ].forEach((f) => {
//     f.addEnvironment(`${key.toUpperCase()}_TABLE`, t.tableName);
//     t.grantFullAccess(f.resources.lambda);
//   })
// }



// // loopStepFunctionStack(backend.stack, 'LoopStepFunction', {
// //   fetchLambda: backend.fetchItemFunction.resources.lambda,
// //   processLambda: backend.processItemFunction.resources.lambda,
// //   targetTable: tables.ImportData,
// // });




