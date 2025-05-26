import { defineFunction } from "@aws-amplify/backend";

export const createActionFunction = defineFunction({
    name: "create-action-function",
    entry: "./handler.ts",
    resourceGroupName: "data",
    environment: {
        SERVICE_NAME: "create-action-function"
    },
});
