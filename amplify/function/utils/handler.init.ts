
import { env } from "$amplify/env/init-data-function";
import { logger } from "../lib/logger";
import { itemServices } from '../lib/item-services';
import { Schema } from "@schema"; // Adjusted the path to the correct module


import { truncateTable } from "../lib/table.service";
import { IMPORT_SERVICE_USER_ID, UNKNOWN_EXTERNAL_USER_ID } from "../lib/constants";
import { DynamoService } from "../lib/dynamodb-service";

export const totalDbService = new DynamoService<Schema['Total']['type']>(process.env.TOTAL_TABLE!);

export const handler = async (event: unknown) => {
    logger.info(`Reset all data table event: ${JSON.stringify(event)}`);

    itemServices.importUser({
        id: UNKNOWN_EXTERNAL_USER_ID,
        name: 'UnknownExternalUser',
        user_type: 'Service',
    });
    itemServices.importUser({
        id: IMPORT_SERVICE_USER_ID,
        name: 'ImportServiceUser',
        user_type: 'Service',
    });

    const models = JSON.parse(env.MODELS);
    logger.info(`Resetting data for models: ${env.MODELS}`);
    for (const [modelName, index] of models) {
        const name = modelName.toUpperCase() + '_TABLE';
        await truncateTable(name, index);
        await totalDbService.upsert(
            { name: modelName },
            { val: 0 },
        );
    }

    return `Data initialized successfully`;

}
