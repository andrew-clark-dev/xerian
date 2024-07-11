import { Handler } from 'aws-lambda';
import { env } from "$amplify/env/add-user-to-group"

import {
    CognitoIdentityProviderClient,
    ListUsersCommand,
} from "@aws-sdk/client-cognito-identity-provider"

const client = new CognitoIdentityProviderClient()

export const handler: Handler = async (event, context) => {
    const command = new ListUsersCommand({
        UserPoolId: env.AMPLIFY_AUTH_USERPOOL_ID,
    })
    const response = await client.send(command)
    return response
};