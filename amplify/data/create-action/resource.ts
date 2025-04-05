import { defineFunction } from "@aws-amplify/backend";

export const createActionFunction = defineFunction({
    name: "create-action-function",
    resourceGroupName: "data",
});