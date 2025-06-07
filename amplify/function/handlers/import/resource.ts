import { defineFunction, secret } from "@aws-amplify/backend";
import { Duration } from "aws-cdk-lib";

export const fetchItemFunction = defineFunction({
    name: "fetch-item-function",
    entry: "./handler.fetch.item.ts",
    resourceGroupName: "data",
    timeoutSeconds: Duration.minutes(10).toSeconds(),
    environment: {
        SERVICE_NAME: "fetch-item-function",
        API_KEY: secret('api-key')
    },
});

export const processItemFunction = defineFunction({
    name: "process-item-function",
    entry: "./handler.process.item.ts",
    resourceGroupName: "data",
    timeoutSeconds: Duration.minutes(14).toSeconds(),
    environment: {
        SERVICE_NAME: "process-item-function"
    },
});

// export const fetchSaleFunction = defineFunction({
//     name: "fetch-sale-function",
//     entry: "./handler.fetch.sale.ts",
//     resourceGroupName: "data",
//     timeoutSeconds: Duration.minutes(10).toSeconds(),
//     environment: {
//         SERVICE_NAME: "fetch-sale-functio",
//         API_KEY: secret('api-key')
//     },
// });

// export const importSaleFunction = defineFunction({
//     name: "import-item-function",
//     entry: "./handler.sale.ts",
//     resourceGroupName: "data",
//     timeoutSeconds: Duration.minutes(14).toSeconds(),
//     environment: {
//         SERVICE_NAME: "import-item-function",
//         API_KEY: secret('api-key')
//     },
// });
