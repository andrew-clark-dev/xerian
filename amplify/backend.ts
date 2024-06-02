import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { Function } from 'aws-cdk-lib/aws-lambda';
import { Code, Runtime } from 'aws-cdk-lib/aws-lambda';
import { IBucket, EventType, Bucket } from 'aws-cdk-lib/aws-s3';
import { S3EventSourceV2 } from 'aws-cdk-lib/aws-lambda-event-sources';

import { importFunction } from './custom-resources/resource'
/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  storage,
});

/**
 * @see https://docs.amplify.aws/gen1/flutter/tools/cli/custom/cdk/ Use CDK to add custom AWS resources
 */
const customStack = backend.createStack('pythonFunctions');

const accountImport = importFunction(customStack, 'account', backend.data.resources.tables['Account'])
const itemImport = importFunction(customStack, 'item', backend.data.resources.tables['Item'])
const saleImport = importFunction(customStack, 'sale', backend.data.resources.tables['Sale'])
