
import { Function, IEventSource, LayerVersion } from 'aws-cdk-lib/aws-lambda';
import { IBucket } from 'aws-cdk-lib/aws-s3';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { Code, Runtime } from 'aws-cdk-lib/aws-lambda';
import { Duration, Stack, aws_events } from 'aws-cdk-lib';
import { IEventBus } from 'aws-cdk-lib/aws-events';
import { Effect, PolicyDocument, PolicyStatement, Role, ServicePrincipal } from 'aws-cdk-lib/aws-iam';

export function backendFunction(
    stack: Stack,
    functionName: string,
    environment: { [key: string]: string; },
    tables: ITable[] = [],
    buckets: IBucket[] = [],
    eventSource?: IEventSource,
): Function {
    console.log(`Creating function - ${functionName}`);

    const lambdaFunction = new Function(
        stack,
        `${functionName}-function`,
        {
            runtime: Runtime.PYTHON_3_12,
            code: Code.fromAsset(`./amplify/custom-resources/${functionName}/`),
            handler: 'function.handler',
            timeout: Duration.seconds(900),
            memorySize: 1024,
            layers: [LayerVersion.fromLayerVersionArn(
                stack,
                `AWSSDKPandas-Python312-Arm64-${functionName}`,
                'arn:aws:lambda:eu-central-1:336392948345:layer:AWSSDKPandas-Python312:8')],
            environment: environment
        })

    tables.forEach((table) => {
        table.grantFullAccess(lambdaFunction)
    })

    buckets?.forEach((bucket) => {
        bucket.grantReadWrite(lambdaFunction)
    })

    if (eventSource) {
        lambdaFunction.addEventSource(eventSource)
        if (eventSource) console.log(`EventSource added`)
    }

    return lambdaFunction
}

/**
 * 
 * @param stack https://docs.amplify.aws/flutter/build-a-backend/data/custom-business-logic/connect-eventbridge-datasource/
 * @param graphqlApiArn 
 * @param attrGraphQlEndpointArn 
 * @param environment 
 * @param tables 
 * @param buckets 
 * @param eventSource 
 * @returns IEventBus
 */
export function createEventBus(
    stack: Stack,
    graphqlApiArn: string,
    attrGraphQlEndpointArn: string,
): IEventBus {
    const name = "XerianEventBus"
    console.log(`Creating eventbus - ${name}`);

    // Reference or create an EventBridge EventBus
    const eventBus = aws_events.EventBus.fromEventBusName(
        stack,
        name,
        "default"
    );

    // Create a policy statement to allow invoking the AppSync API's mutations
    const policyStatement = new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["appsync:GraphQL"],
        resources: [`${graphqlApiArn}/types/Mutation/*`],
    });

    // Create a role for the EventBus to assume
    const eventBusRole = new Role(stack, "AppSyncInvokeRole", {
        assumedBy: new ServicePrincipal("events.amazonaws.com"),
        inlinePolicies: {
            PolicyStatement: new PolicyDocument({
                statements: [policyStatement],
            }),
        },
    });

    // Create an EventBridge rule to route events to the AppSync API
    const rule = new aws_events.CfnRule(stack, "ServerEventRule", {
        eventBusName: eventBus.eventBusName,
        name: "broadcastServerEvent",
        eventPattern: {
            source: ["amplify.server-events"],
            /* The shape of the event pattern must match EventBridge's event message structure.
            So, this field must be spelled as "detail-type". Otherwise, events will not trigger the rule.

            https://docs.aws.amazon.com/AmazonS3/latest/userguide/ev-events.html
            */
            ["detail-type"]: ["ServerEvent"],
            detail: {
                eventId: [{ exists: true }],
                eventType: ["MODELSYNC", "REPORT", "NOTIFICATION", "UNDEFINED"],
                modelType: [{ exists: true }],
                payload: [{ exists: true }],
            },
        },
        targets: [
            {
                id: "serverEventReceiver",
                arn: attrGraphQlEndpointArn,
                roleArn: eventBusRole.roleArn,
                appSyncParameters: {
                    graphQlOperation: `
          mutation PublishServerEventFromEventBridge(
            $eventId: String!
            $eventType: String!
            $modelType: String!
            $payload: String!
          ) {
            publishServerEventFromEventBridge(eventId: $eventId, eventType: $eventType, modelType: $modelType, payload: $payload) {
              eventId
              eventType
              modelType
              payload
            }
          }`,
                },
                inputTransformer: {
                    inputPathsMap: {
                        eventId: "$.detail.eventId",
                        eventType: "$.detail.eventType",
                        modelType: "$.detail.modelType",
                        payload: "$.detail.payload",
                    },
                    inputTemplate: JSON.stringify({
                        eventId: "<eventId>",
                        eventType: "<eventType>",
                        modelType: "<modelType>",
                        payload: "<payload>",
                    }),
                },
            },
        ],
    });


    // // Create an EventBridge rule to route events to the AppSync API
    // const logrule = new aws_events.CfnRule(stack, "eventbridge-logs", {
    //     eventBusName: eventBus.eventBusName,
    //     name: "eventbridge-logs",
    //     eventPattern: {
    //         source: ["amplify.server-events"]
    //     },
    //     targets: [
    //         {
    //             id: "serverEventReceiver",
    //             arn: attrGraphQlEndpointArn,
    //             roleArn: eventBusRole.roleArn,
    //             appSyncParameters: {
    //                 graphQlOperation: `
    //       mutation PublishServerEventFromEventBridge(
    //         $eventId: String!
    //         $eventType: String!
    //         $modelType: String!
    //         $payload: String!
    //       ) {
    //         publishServerEventFromEventBridge(eventId: $eventId, eventType: $eventType, modelType: $modelType, payload: $payload) {
    //           eventId
    //           eventType
    //           modelType
    //           payload
    //         }
    //       }`,
    //             },
    //             inputTransformer: {
    //                 inputPathsMap: {
    //                     eventId: "$.detail.eventId",
    //                     eventType: "$.detail.eventType",
    //                     modelType: "$.detail.modelType",
    //                     payload: "$.detail.payload",
    //                 },
    //                 inputTemplate: JSON.stringify({
    //                     eventId: "<eventId>",
    //                     eventType: "<eventType>",
    //                     modelType: "<modelType>",
    //                     payload: "<payload>",
    //                 }),
    //             },
    //         },
    //     ],
    // });


    return eventBus;

}