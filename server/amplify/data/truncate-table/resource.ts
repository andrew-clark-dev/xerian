import { defineFunction } from "@aws-amplify/backend";

export const truncateTableFunction = defineFunction({
    name: "truncate-table-function",
    resourceGroupName: "data",
    timeoutSeconds: 900, // 10 minute timeout
    memoryMB: 1024 // allocate 1024 MB of memory to the function.
});