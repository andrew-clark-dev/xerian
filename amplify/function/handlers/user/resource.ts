import { defineFunction } from "@aws-amplify/backend";
import { Duration } from "aws-cdk-lib";

export const provisionUserFunction = defineFunction({
    name: "provision-user-function",
    entry: "./handler.provision.ts",
    timeoutSeconds: Duration.minutes(1).toSeconds(),
    environment: {
        SERVICE_NAME: "provision-user-function",
    },
});




