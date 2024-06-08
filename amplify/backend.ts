import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';

import { importFunction } from './custom-resources/resource'
import { opensearchDomain } from './custom-resources/resource'
import { opensearchPipeline } from './custom-resources/resource'
import { Stack } from 'aws-cdk-lib';

/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  storage,
});

/**
 * @see https://docs.amplify.aws/flutter/build-a-backend/data/custom-business-logic/search-and-aggregate-queries/ 
 * Connect to Amazon OpenSearch for search and aggregate queries
*/
const dataStack = Stack.of(backend.data);

const osDomain = opensearchDomain(dataStack)

opensearchPipeline(dataStack,
  'account',
  osDomain,
  backend.data.resources.tables['Account'],
  backend.data.resources.cfnResources.amplifyDynamoDbTables['Account'],
  backend.storage.resources.bucket
)

opensearchPipeline(dataStack,
  'category',
  osDomain,
  backend.data.resources.tables['Category'],
  backend.data.resources.cfnResources.amplifyDynamoDbTables['Category'],
  backend.storage.resources.bucket
)

const osDataSource = backend.data.addOpenSearchDataSource("osDataSource", osDomain);

// /**
//  * @see https://docs.amplify.aws/gen1/flutter/tools/cli/custom/cdk/ Use CDK to add custom AWS resources
//  */
const customStack = backend.createStack('pythonFunctions');

const accountImport = importFunction(customStack, 'account', backend.data.resources.tables['Account'])
const itemImport = importFunction(customStack, 'item', backend.data.resources.tables['Item'])
const saleImport = importFunction(customStack, 'sale', backend.data.resources.tables['Sale'])