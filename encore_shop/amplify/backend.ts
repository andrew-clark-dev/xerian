import { defineBackend } from '@aws-amplify/backend';
import { defineFunction } from '@aws-amplify/backend';


import { auth } from './auth/resource';
import { data } from './data/resource';
import { openSearchBackup } from "./storage/resource";



import * as dynamodb from "aws-cdk-lib/aws-dynamodb";
import * as opensearch from "aws-cdk-lib/aws-opensearchservice";
import * as iam from "aws-cdk-lib/aws-iam";

import { Stack } from "aws-cdk-lib";
import { RemovalPolicy } from "aws-cdk-lib";

import * as osis from "aws-cdk-lib/aws-osis";
import * as logs from "aws-cdk-lib/aws-logs";

/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  openSearchBackup,
});


// extract L1 CfnUserPool resources
const { cfnUserPool } = backend.auth.resources.cfnResources;
// use CDK's `addPropertyOverride` to modify properties directly
cfnUserPool.addPropertyOverride(
  "Policies",
  {
    PasswordPolicy: {
      MinimumLength: 20,
      RequireLowercase: false,
      RequireNumbers: false,
      RequireSymbols: false,
      RequireUppercase: false,
      TemporaryPasswordValidityDays: 20,
    },
  }
);


export const importAccounts = defineFunction({
  // optionally specify a name for the Function (defaults to directory name)
  name: 'import-accounts',
  // optionally specify a path to your handler (defaults to "./handler.ts")
  entry: './handler.ts'
});


const accountTable =
  backend.data.resources.cfnResources.amplifyDynamoDbTables["Account"];


// Update table settings
accountTable.pointInTimeRecoveryEnabled = true;


accountTable.streamSpecification = {
  streamViewType: dynamodb.StreamViewType.NEW_IMAGE,
};


// Get the DynamoDB table ARN
const tableArn = backend.data.resources.tables["Account"].tableArn;
// Get the DynamoDB table name
const tableName = backend.data.resources.tables["Account"].tableName;


// Get the data stack
const dataStack = Stack.of(backend.data);

// Create the OpenSearch domain
const openSearchDomain = new opensearch.Domain(
  dataStack,
  "OpenSearchDomain",
  {
    version: opensearch.EngineVersion.OPENSEARCH_2_11,
    nodeToNodeEncryption: true,
    encryptionAtRest: {
      enabled: true,
    },
    capacity: {
      dataNodeInstanceType: 't3.small.search',
    },

    // coldStorageEnabled: true,
  }
);


// Get the S3Bucket ARN
const openSearchs3BucketArn = backend.openSearchBackup.resources.bucket.bucketArn;
// Get the S3Bucket Name
const openSearchs3BucketName = backend.openSearchBackup.resources.bucket.bucketName;


//Get the region
const region = dataStack.region;


// Create an IAM role for OpenSearch integration
const openSearchIntegrationPipelineRole = new iam.Role(
  dataStack,
  "OpenSearchIntegrationPipelineRole",
  {
    assumedBy: new iam.ServicePrincipal("osis-pipelines.amazonaws.com"),
    inlinePolicies: {
      openSearchPipelinePolicy: new iam.PolicyDocument({
        statements: [
          new iam.PolicyStatement({
            actions: ["es:DescribeDomain"],
            resources: [
              openSearchDomain.domainArn,
              openSearchDomain.domainArn + "/*",
            ],
            effect: iam.Effect.ALLOW,
          }),
          new iam.PolicyStatement({
            actions: ["es:ESHttp*"],
            resources: [
              openSearchDomain.domainArn,
              openSearchDomain.domainArn + "/*",
            ],
            effect: iam.Effect.ALLOW,
          }),
          new iam.PolicyStatement({
            effect: iam.Effect.ALLOW,
            actions: [
              "s3:GetObject",
              "s3:AbortMultipartUpload",
              "s3:PutObject",
              "s3:PutObjectAcl",
            ],
            resources: [openSearchs3BucketArn, openSearchs3BucketArn + "/*"],
          }),
          new iam.PolicyStatement({
            effect: iam.Effect.ALLOW,
            actions: [
              "dynamodb:DescribeTable",
              "dynamodb:DescribeContinuousBackups",
              "dynamodb:ExportTableToPointInTime",
              "dynamodb:DescribeExport",
              "dynamodb:DescribeStream",
              "dynamodb:GetRecords",
              "dynamodb:GetShardIterator",
            ],
            resources: [tableArn, tableArn + "/*"],
          }),
        ],
      }),
    },
    managedPolicies: [
      iam.ManagedPolicy.fromAwsManagedPolicyName(
        "AmazonOpenSearchIngestionFullAccess"
      ),
    ],
  }
);




// Define OpenSearch index mappings
const indexName = "account";


const indexMapping = {
  settings: {
    number_of_shards: 1,
    number_of_replicas: 0,
  },
  mappings: {
    properties: {
      id: {
        type: "keyword",
      },
      number: {
        type: "integer",
      },
      firstName: {
        type: "text",
      },
      lastName: {
        type: "text",
      },
    },
  },
};




// OpenSearch template definition
const openSearchTemplate = `
version: "2"
dynamodb-pipeline:
  source:
    dynamodb:
      acknowledgments: true
      tables:
        - table_arn: "${tableArn}"
          stream:
            start_position: "LATEST"
          export:
            s3_bucket: "${openSearchs3BucketName}"
            s3_region: "${region}"
            s3_prefix: "${tableName}/"
      aws:
        sts_role_arn: "${openSearchIntegrationPipelineRole.roleArn}"
        region: "${region}"
  sink:
    - opensearch:
        hosts:
          - "https://${openSearchDomain.domainEndpoint}"
        index: "${indexName}"
        index_type: "custom"
        template_content: |
          ${JSON.stringify(indexMapping)}
        document_id: '\${getMetadata("primary_key")}'
        action: '\${getMetadata("opensearch_action")}'
        document_version: '\${getMetadata("document_version")}'
        document_version_type: "external"
        bulk_size: 4
        aws:
          sts_role_arn: "${openSearchIntegrationPipelineRole.roleArn}"
          region: "${region}"
          serverless: false
`;


// Create a CloudWatch log group
const logGroup = new logs.LogGroup(dataStack, "OpenSearchPipelineLogGroup", {
  logGroupName: "/aws/vendedlogs/OpenSearchService/pipelines/1",
  removalPolicy: RemovalPolicy.DESTROY,
});


// Create an OpenSearch Integration Service pipeline
const cfnPipeline = new osis.CfnPipeline(
  dataStack,
  "OpenSearchIntegrationPipeline",
  {
    maxUnits: 4,
    minUnits: 1,
    pipelineConfigurationBody: openSearchTemplate,
    pipelineName: "dynamodb-integration-1",
    logPublishingOptions: {
      isLoggingEnabled: true,
      cloudWatchLogDestination: {
        logGroup: logGroup.logGroupName,
      },
    }
  }
);

// Add OpenSearch data source 
const osDataSource = backend.data.addOpenSearchDataSource(
  "osDataSource",
  openSearchDomain
);