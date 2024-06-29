import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { backendFunction, createEventBus } from './custom-resources/resource';
import { Stack } from 'aws-cdk-lib/core';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { restApi, MethodType } from './functions/api-functions/resource';
import { IUserPool } from 'aws-cdk-lib/aws-cognito';
import { IRole } from 'aws-cdk-lib/aws-iam';
import { sayHello } from './functions/say-hello/resource';
/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  storage,
  sayHello,
});

const dataStack = Stack.of(backend.data);
const apiStack = backend.createStack("api-stack");
const eventStack = backend.createStack("event-stack");

const userPool: IUserPool = backend.auth.resources.userPool
const role: IRole = backend.auth.resources.authenticatedUserIamRole

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

// Add the EventBridge data source
const eventBus = createEventBus(eventStack, backend.data.resources.graphqlApi.arn, backend.data.resources.cfnResources.cfnGraphqlApi.attrGraphQlEndpointArn)
backend.data.addEventBridgeDataSource("XerianEventBridgeDataSource", eventBus);

// const syncAccountApi = restApi('SyncAccount', apiStack, userPool, role, syncAccountFunction, 'sync-account', [MethodType.Put])
// backend.addOutput(syncAccountApi)
