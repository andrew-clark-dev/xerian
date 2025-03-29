import { Schema } from "../resource";
import { generateClient } from "aws-amplify/data";
import { Logger } from "@aws-lambda-powertools/logger";
import { Amplify } from "aws-amplify";
import { getAmplifyDataClientConfig } from '@aws-amplify/backend/function/runtime';
import { env } from "$amplify/env/init-data-function";


import { truncateTable } from "@/utils/table.service";
import { userService } from "@/utils/user.service";
import { IMPORT_SERVICE_USER_ID } from "../constants";

const logger = new Logger({ serviceName: "init-data-handler" });

const { resourceConfig, libraryOptions } = await getAmplifyDataClientConfig(env);

Amplify.configure(resourceConfig, libraryOptions);

const client = generateClient<Schema>();

export const handler = async (event: unknown) => {
    logger.info(`Reset all data table event: ${JSON.stringify(event)}`);

    userService.provisionServiceUser('UnknownExternalUser', '0d1cd38e-551f-4c9e-b753-275d0e073bba');
    userService.provisionServiceUser('ImportServiceUser', IMPORT_SERVICE_USER_ID);

    const models = JSON.parse(env.MODELS);
    logger.info(`Resetting data for models: ${env.MODELS}`);
    for (const [modelName, index] of models) {
        const name = modelName.toUpperCase() + '_TABLE';
        await truncateTable(name, index);
        const { errors } = await client.models.Total.create({ name: modelName, val: 0 });
        if (errors) {
            const { errors } = await client.models.Total.update({ name: modelName, val: 0 });
            if (errors) {
                logger.error(`Failed to reset model total for: ${modelName}`);
            }
        }
    }
    return `Data initialized successfully`;

};
