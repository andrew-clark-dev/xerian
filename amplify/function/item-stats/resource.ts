import { defineFunction } from "@aws-amplify/backend";

export const itemStatsFunction = defineFunction({
    name: "item-stats-function",
    entry: "./handler.ts",
    resourceGroupName: "data",
    environment: {
        SERVICE_NAME: "item-stats-function"
    },
});
