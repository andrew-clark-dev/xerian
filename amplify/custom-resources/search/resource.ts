import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { AmplifyDynamoDbTableWrapper } from "@aws-amplify/graphql-api-construct"
import { RemovalPolicy } from "aws-cdk-lib";
import { IBucket } from 'aws-cdk-lib/aws-s3';
import * as logs from "aws-cdk-lib/aws-logs";
import * as osis from "aws-cdk-lib/aws-osis";
import * as iam from "aws-cdk-lib/aws-iam";
import * as dynamodb from "aws-cdk-lib/aws-dynamodb";
import * as opensearch from "aws-cdk-lib/aws-opensearchservice";
import { Stack } from "aws-cdk-lib";

export function opensearchDomain(stack: Stack) {
    // Create the OpenSearch domain
    const openSearchDomain = new opensearch.Domain(
        stack,
        "OpenSearchDomain",
        {
            version: opensearch.EngineVersion.OPENSEARCH_2_11,
            // nodeToNodeEncryption: true,
            // encryptionAtRest: {
            //     enabled: true,
            // },
            capacity: {
                masterNodes: 0,
                dataNodes: 1,
                dataNodeInstanceType: 't2.small.search', // Specify the instance type here
            },

            ebs: {
                volumeSize: 10,
            },

            removalPolicy: RemovalPolicy.DESTROY,
        }
    );

    // Create a CloudWatch log group
    // const logGroup = new logs.LogGroup(stack, "LogGroup", {
    //     logGroupName: "/aws/vendedlogs/OpenSearchService/pipelines",
    //     removalPolicy: RemovalPolicy.DESTROY,
    // });

    return openSearchDomain!;

}

export function opensearchPipeline(stack: Stack, indexName: string, openSearchDomain: opensearch.Domain, table: ITable, cfnTable: AmplifyDynamoDbTableWrapper, bucket: IBucket) {
    // Update table settings
    cfnTable.pointInTimeRecoveryEnabled = true;

    cfnTable.streamSpecification = {
        streamViewType: dynamodb.StreamViewType.NEW_IMAGE,
    };
    // Create an IAM role for OpenSearch integration
    const openSearchIntegrationPipelineRole = new iam.Role(
        stack,
        `OpenSearchIntegrationPipelineRole-${indexName}`,
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
                            resources: [bucket.bucketArn, bucket.bucketArn + "/*"],
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
                            resources: [table.tableArn, table.tableArn + "/*"],
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


    // OpenSearch template definition
    const openSearchTemplate = `
version: "2"
dynamodb-pipeline:
  source:
    dynamodb:
      acknowledgments: true
      tables:
        - table_arn: "${table.tableArn}"
          stream:
            start_position: "LATEST"
          export:
            s3_bucket: "${bucket.bucketName}"
            s3_region: "${stack.region}"
            s3_prefix: "${table.tableName}/"
      aws:
        sts_role_arn: "${openSearchIntegrationPipelineRole.roleArn}"
        region: "${stack.region}"
  sink:
    - opensearch:
        hosts:
          - "https://${openSearchDomain.domainEndpoint}"
        index: "${indexName}"
        index_type: "custom"
        document_id: '\${getMetadata("primary_key")}'
        action: '\${getMetadata("opensearch_action")}'
        document_version: '\${getMetadata("document_version")}'
        document_version_type: "external"
        bulk_size: 4
        aws:
          sts_role_arn: "${openSearchIntegrationPipelineRole.roleArn}"
          region: "${stack.region}"
`;

    // Create an OpenSearch Integration Service pipeline
    const cfnPipeline = new osis.CfnPipeline(
        stack,
        `OpenSearchIntegrationPipeline-${indexName}`,
        {
            maxUnits: 4,
            minUnits: 1,
            pipelineConfigurationBody: openSearchTemplate,
            pipelineName: `db-integration-${indexName}`,
            // logPublishingOptions: {
            //     isLoggingEnabled: true,
            //     cloudWatchLogDestination: {
            //         logGroup: "/aws/vendedlogs/OpenSearchService/pipelines",
            //     },
            // },
        }
    );


}





