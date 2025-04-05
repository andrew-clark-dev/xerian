import { truncateTable } from "@server/table.service";
import { logger } from "@server/logger";

export const handler = async (event: { table_env_var: string, index: string[] }) => {

    logger.info(`Truncating table with event`, event);
    await truncateTable(event.table_env_var, event.index);
    return `Table truncated successfully`;

};
