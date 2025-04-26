import { defineFunction } from "@aws-amplify/backend";

export const initDataFunction = defineFunction({
    name: "init-data-function",
    resourceGroupName: "data",
    timeoutSeconds: 900, // 10 minute timeout
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
            ['ImportData', ['id']],
        ])
    }
});