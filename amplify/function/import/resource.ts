import { defineFunction, secret } from "@aws-amplify/backend";
import { Duration } from "aws-cdk-lib";


export const importItemFunction = defineFunction({
    name: "import-item-function",
    entry: "./handler.item.ts",
    resourceGroupName: "data",
    timeoutSeconds: 30,
    environment: {
        SERVICE_NAME: "import-item-function"
    },
});

export const importFetchFunction = defineFunction({
    name: "import-fetch-function",
    entry: "./handler.fetch.ts",
    resourceGroupName: "data",
    timeoutSeconds: Duration.minutes(10).toSeconds(),
    environment: {
        SERVICE_NAME: "import-fetch-function",
        API_KEY: secret('api-key')
    },
});