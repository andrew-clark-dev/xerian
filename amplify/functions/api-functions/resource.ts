import { IFunction } from 'aws-cdk-lib/aws-lambda';
import { Stack } from 'aws-cdk-lib';
import { AuthorizationType, CognitoUserPoolsAuthorizer, Cors, LambdaIntegration, RestApi } from 'aws-cdk-lib/aws-apigateway';
import { IUserPool } from 'aws-cdk-lib/aws-cognito';
import { IRole, Policy, PolicyStatement } from 'aws-cdk-lib/aws-iam';
import { DeepPartialAmplifyGeneratedConfigs } from '@aws-amplify/plugin-types/lib/deep_partial'
import { ClientConfig } from '@aws-amplify/client-config'


export enum MethodType {
    Get = "GET",
    Post = "POST",
    Delete = "DELETE",
    Put = "PUT",
}

/**
 * 
 * @param stack All from https://docs.amplify.aws/react/build-a-backend/add-aws-services/rest-api/set-up-rest-api/
 * @param userPool 
 * @param role 
 * @param lambda 
 * @param pathPart 
 * @returns 
 */

export function restApi(
    apiName: string,
    stack: Stack,
    userPool: IUserPool,
    role: IRole,
    lambda: IFunction,
    pathPart: string,
    methodTypes: MethodType[] = [MethodType.Get, MethodType.Post, MethodType.Delete, MethodType.Put]
): DeepPartialAmplifyGeneratedConfigs<ClientConfig> {
    console.log(`Creating rest api for  - ${apiName}`);
    // create a new REST API
    const restApi = new RestApi(stack, `${apiName}RestApi`, {
        restApiName: `${apiName}RestApi`,
        deploy: true,
        deployOptions: {
            stageName: "dev",
        },
        defaultCorsPreflightOptions: {
            allowOrigins: Cors.ALL_ORIGINS, // Restrict this to domains you trust
            allowMethods: Cors.ALL_METHODS, // Specify only the methods you need to allow
            allowHeaders: Cors.DEFAULT_HEADERS, // Specify only the headers you need to allow
        },
    });

    // create a new Lambda integration
    const lambdaIntegration = new LambdaIntegration(lambda);

    // create a new Cognito User Pools authorizer
    const cognitoAuth = new CognitoUserPoolsAuthorizer(stack, "CognitoAuth", {
        cognitoUserPools: [userPool],
    });

    // create a new resource path with IAM authorization
    const path = restApi.root.addResource(pathPart, {
        defaultMethodOptions: {
            authorizationType: AuthorizationType.COGNITO,
            authorizer: cognitoAuth,
        },
    });

    // add methods you would like to create to the resource path
    methodTypes.forEach((methodType) => path.addMethod(methodType, lambdaIntegration))

    // add a proxy resource path to the API
    path.addProxy({
        anyMethod: true,
        defaultIntegration: lambdaIntegration,
    });

    const executeApi = restApi.arnForExecuteApi("*", `/${path}`, "dev")
    const executeApiList = restApi.arnForExecuteApi("*", `/${path}/*`, "dev")
    const apiRestPolicy = new Policy(stack, "RestApiPolicy", {
        statements: [
            new PolicyStatement({
                actions: ["execute-api:Invoke"],
                resources: [executeApi, executeApiList,],
            }),
        ],
    });

    // attach the policy to the authenticated and unauthenticated IAM roles
    role.attachInlinePolicy(apiRestPolicy);

    return {
        custom: {
            API: {
                [restApi.restApiName]: {
                    url: restApi.url + pathPart,
                    region: stack.region,
                    apiName: restApi.restApiName,
                    authorization_type: 'AMAZON_COGNITO_USER_POOL'
                },
            },
        },
    }
}
