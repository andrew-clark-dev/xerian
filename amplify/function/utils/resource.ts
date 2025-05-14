import { defineFunction } from "@aws-amplify/backend";
import { Duration } from "aws-cdk-lib";

export const truncateTableFunction = defineFunction({
    name: "truncate-table-function",
    entry: "./handler.truncate.ts",
    resourceGroupName: "data",
    timeoutSeconds: Duration.minutes(10).toSeconds(), // 10 minute timeout
    memoryMB: 1024 // allocate 1024 MB of memory to the function.
});

export const initDataFunction = defineFunction({
    name: "init-data-function",
    entry: "./handler.init.ts",
    resourceGroupName: "data",
    timeoutSeconds: Duration.minutes(15).toSeconds(), // 15 minute timeout
    memoryMB: 1024, // allocate 1024 MB of memory to the function.
    environment: {
        MODELS: JSON.stringify([
            ['Account', ['number']],
            ['Action', ['id']],
            ['Comment', ['id']],
            ['Item', ['sku']],
            ['ItemGroup', ['id']],
            ['Transaction', ['id']],
            ['ItemCategory', ['kind', 'name']],
            ['Sale', ['number']],
            ['Notification', ['id', 'createdAt']],
            ['ItemStats', ['itemSku', 'createdAt']],
            ['SaleStats', ['saleNumber', 'createdAt']],
            // ['ImportData', ['id']],
        ])
    }
});