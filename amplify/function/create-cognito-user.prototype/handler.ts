import {
    CognitoIdentityProviderClient,
    AdminCreateUserCommand,
} from "@aws-sdk/client-cognito-identity-provider";
import { CloudFormationCustomResourceEvent, Context } from "aws-lambda";
import * as https from "https";
import * as url from "url";

const cognitoClient = new CognitoIdentityProviderClient({});

export const handler = async (
    event: CloudFormationCustomResourceEvent,
    context: Context
): Promise<void> => {
    console.log("Event: ", JSON.stringify(event, null, 2));

    const sendResponse = (status: "SUCCESS" | "FAILED", reason?: string) => {
        const responseBody = JSON.stringify({
            Status: status,
            Reason: reason || "See CloudWatch log stream: " + context.logStreamName,
            PhysicalResourceId: "createCognitoUser",
            StackId: event.StackId,
            RequestId: event.RequestId,
            LogicalResourceId: event.LogicalResourceId,
            Data: {},
        });

        const parsedUrl = url.parse(event.ResponseURL);
        const options = {
            hostname: parsedUrl.hostname!,
            port: 443,
            path: parsedUrl.path!,
            method: "PUT",
            headers: {
                "Content-Type": "",
                "Content-Length": Buffer.byteLength(responseBody),
            },
        };

        return new Promise<void>((resolve, reject) => {
            const request = https.request(options, (response) => {
                console.log(`Status code: ${response.statusCode}`);
                resolve();
            });

            request.on("error", (error) => {
                console.error("sendResponse Error:", error);
                reject(error);
            });

            request.write(responseBody);
            request.end();
        });
    };

    if (event.RequestType === "Delete") {
        await sendResponse("SUCCESS");
        return;
    }

    const userPoolId = process.env.USER_POOL_ID!;
    const email = process.env.NEW_USER_EMAIL!;
    const tempPassword = process.env.NEW_USER_TEMP_PASSWORD!;

    try {
        if (event.RequestType === "Create") {
            await cognitoClient.send(
                new AdminCreateUserCommand({
                    UserPoolId: userPoolId,
                    Username: email,
                    TemporaryPassword: tempPassword,
                    UserAttributes: [
                        { Name: "email", Value: email },
                        { Name: "email_verified", Value: "true" },
                    ],
                    MessageAction: "SUPPRESS", // Don't send welcome email
                })
            );
        }

        await sendResponse("SUCCESS");
    } catch (err) {
        console.error("User creation failed", err);
        await sendResponse("FAILED", (err as Error).message || "Error creating user");
    }
};
