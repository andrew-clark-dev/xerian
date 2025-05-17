import { defineFunction } from "@aws-amplify/backend";

export const salesStatsFunction = defineFunction({
    name: "sale-stats-function",
    entry: "./handler.ts",
    resourceGroupName: "data",
    environment: {
        SERVICE_NAME: "sale-stats-function"
    },
});
