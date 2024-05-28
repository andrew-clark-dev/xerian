import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { importAccountCsv } from './functions/import/resource';

import { aws_lambda as lambda } from 'aws-cdk-lib';
import { Code, Runtime } from 'aws-cdk-lib/aws-lambda';
import * as eventsources from 'aws-cdk-lib/aws-lambda-event-sources';

/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  storage,
  importAccountCsv,
});

/**
 * importAccountCsv is triggers from the storage resource.
 * We need to set the table name in the environment variable, and provide access so the function can write to the table.
 */
const accountTable = backend.data.resources.tables['Account'];
backend.importAccountCsv.resources.cfnResources.cfnFunction.environment = { variables: { 'table_name': accountTable.tableName } }
accountTable.grantWriteData(backend.importAccountCsv.resources.lambda)

// const customResourceStack = backend.createStack('pythonFunctions');

// const bucket = backend.storage.resources.bucket;
// const bucket2 = backend.storage.resources.cfnResources.cfnBucket;

// const importAccounts = new lambda.Function(customResourceStack, 'ImportAccountCSV',
//    { runtime: Runtime.PYTHON_3_12, code: Code.fromAsset('backend/function/import-accounts/src/'), handler: 'function.handler' })
// importAccounts.addEnvironment('table_name', accountTable.tableName);
// accountTable.grantWriteData(importAccounts)
// bucket.grantRead(importAccounts)
// importAccounts.addEventSource(new eventsources.S3EventSource(bucket, { events: [eventsources.S3EventSource.EVENTS.OBJECT_CREATED] }))



