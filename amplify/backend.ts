import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { backendFunction, createEventBus } from './custom-resources/resource';
import { Stack } from 'aws-cdk-lib/core';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { EventbridgeToLambdaProps, EventbridgeToLambda } from '@aws-solutions-constructs/aws-eventbridge-lambda';
import { aws_events } from 'aws-cdk-lib';
import { LogGroup } from 'aws-cdk-lib/aws-logs';
import { CloudWatchLogGroup } from 'aws-cdk-lib/aws-events-targets';
import { eventBridge } from './custom-resources/eventbridge/resource';

/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  storage,
})

const dataStack = Stack.of(backend.data);
const eventStack = backend.createStack("event-stack");

const accountTable: ITable = backend.data.resources.tables['Account']
const syncTable: ITable = backend.data.resources.tables['SyncInfo']


var env: { [key: string]: string } = {
  ACCOUNT_TABLE: accountTable.tableName,
  SYNC_TABLE: syncTable.tableName,
}

// /**
//  * @see https://docs.amplify.aws/gen1/flutter/tools/cli/custom/cdk/ Use CDK to add custom AWS resources
//  */
const syncAccountFunction = backendFunction(dataStack, 'sync-account', env, [accountTable, syncTable])
const truncateTableFunction = backendFunction(dataStack, 'truncate-table', env, [accountTable, syncTable])

const eventBus = eventBridge(eventStack, "event-bus")

// Add the EventBridge data source
const eventBridgeDataSource = backend.data.addEventBridgeDataSource("EventBridgeDataSource", eventBus);


// eventBus.grantPutEventsTo(syncAccountFunction)

// const constructProps: EventbridgeToLambdaProps = {
//   existingLambdaObj: syncAccountFunction,
//   eventRuleProps: {
//     eventBus: eventBus,
//     eventPattern: {
//       source: ['amplify.frontend'],
//       detailType: ['modelsync']
//     }
//   },
// };

// const eventbridgeToLambda = new EventbridgeToLambda(dataStack, 'modelsync-lambda', constructProps);


// // Add the EventBridge data source
// // const eventBus = createEventBus(eventStack, backend.data.resources.graphqlApi.arn, backend.data.resources.cfnResources.cfnGraphqlApi.attrGraphQlEndpointArn)
// backend.data.addEventBridgeDataSource("EventBridgeDataSource", eventBus);