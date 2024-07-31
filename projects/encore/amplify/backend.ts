import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { accountImport, itemImport, truncateTable } from './function/resource';
import { Stack } from 'aws-cdk-lib/core';
import { PolicyStatement } from 'aws-cdk-lib/aws-iam';

/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  storage
});

const bucketStack = Stack.of(backend.storage.resources.bucket);
const dataStack = Stack.of(backend.data);
// extract L1 CfnUserPool resources
const { cfnUserPool } = backend.auth.resources.cfnResources;
// modify cfnUserPool policies directly
cfnUserPool.policies = {
  passwordPolicy: {
    minimumLength: 20,
    requireLowercase: true,
    requireNumbers: true,
    requireSymbols: false,
    requireUppercase: false,
    temporaryPasswordValidityDays: 20,
  },
};


backend.data.apiId
backend.data.apiKey

const { bucket } = backend.storage.resources
const { tables } = backend.data.resources

// The first bucket given 
const env: { [key: string]: string } = {
  API_ID: backend.data.apiId,
  AMPLIFY_ENV: dataStack.environment,
  BUCKET_NAME: bucket.bucketName,
  ACCOUNT_TABLE_NAME: tables['Account'].tableName,
  ITEM_TABLE_NAME: tables['Item'].tableName,
  CATEGORY_TABLE_NAME: tables['Category'].tableName,
  BRAND_TABLE_NAME: tables['Brand'].tableName,
  COLOR_TABLE_NAME: tables['Color'].tableName,
  SIZE_TABLE_NAME: tables['Size'].tableName,
}

console.log(`Env - ${env}`);

const accountImportFunction = accountImport(env, tables['Account'], bucket);
const itemImportFunction = itemImport(env, [tables['Item'], tables['Account']], bucket);
itemImportFunction.addToRolePolicy(
  new PolicyStatement({
    actions: ['dynamodb:Query'],
    resources: [`${tables['Account'].tableArn}/index/*`],
  }),
);
const truncateTableFunction = truncateTable([tables['Account'], tables['Item']])


