import { defineFunction, secret } from "@aws-amplify/backend";
import { IMPORT_DIR } from "../../data/constants";
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

export const importReceiveFunction = defineFunction({
    name: "import-receive-function",
    entry: "./handler.receive.ts",
    resourceGroupName: "data",
    timeoutSeconds: Duration.minutes(10).toSeconds(),
    environment: {
        IMPORT_DIR: IMPORT_DIR,
        SERVICE_NAME: "import-receive-function",
        API_KEY: secret('api-key')
    },
});