import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { Stack } from 'aws-cdk-lib/core';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { backendFunction } from './custom-resources/function/resource';
import { configureEventBridge, eventbridgeToLambda } from './custom-resources/eventbridge/resource';
import { aws_cognito as cognito } from 'aws-cdk-lib';
import { CfnUserPoolUser } from 'aws-cdk-lib/aws-cognito';
import { AdminUser } from './custom-resources/admin-user/AdminUser';
import { UserPoolUser } from './custom-resources/admin-user/UserPoolUser';
import { Secret } from 'aws-cdk-lib/aws-secretsmanager';

/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  storage,
})

const authStack = backend.createStack("auth-stack");
const dataStack = Stack.of(backend.data);
const eventStack = backend.createStack("event-stack");

const { tables } = backend.data.resources

const accountTable: ITable = tables['Account']
const syncTable: ITable = tables['SyncInfo']

const { userPool } = backend.auth.resources

var env: { [key: string]: string } = {
  ACCOUNT_TABLE: accountTable.tableName,
  SYNC_TABLE: syncTable.tableName,
}

// /**
//  * @see https://docs.amplify.aws/gen1/flutter/tools/cli/custom/cdk/ Use CDK to add custom AWS resources
//  */
const syncAccountFunction = backendFunction(dataStack, 'sync-account', env, [accountTable, syncTable])
const truncateTableFunction = backendFunction(dataStack, 'truncate-table', env, [accountTable, syncTable])

const eventBus = configureEventBridge(eventStack, "event-bus")

// Add the EventBridge data source
const eventBridgeDataSource = backend.data.addEventBridgeDataSource("EventBridgeDataSource", eventBus);

const accountSyncBridge = eventbridgeToLambda(dataStack, eventBus, syncAccountFunction, 'frontend.account.sync.request')

// Templated secret with username and password fields
const adminCredsSecret = new Secret(authStack, 'admin-creds-secret', {
  generateSecretString: {
    secretStringTemplate: JSON.stringify({ username: 'andrew.p.clark@protonmail.com' }),
    generateStringKey: 'password',
    excludeCharacters: '/@"',
  },
});

// TODO: This is a temprary solution, I should rewrite the UserPoolUser using cdk resources
const adminUser = new UserPoolUser(authStack, 'admin-user', {
  userPool,
  username: 'andrew.p.clark@protonmail.com',
  password: adminCredsSecret.secretValueFromJson('password').unsafeUnwrap(),
  attributes: [
    { Name: 'email', Value: 'andrew.p.clark@protonmail.com' },
    { Name: 'email_verified', Value: 'true' },
    { Name: 'name', Value: 'XerianAdmin' },
  ],
  groupName: 'ADMINS',
});


