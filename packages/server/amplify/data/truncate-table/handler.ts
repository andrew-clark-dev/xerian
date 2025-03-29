import { truncateTable } from "@/utils/table.service";
import { logger } from "@/utils/logger";

export const handler = async (event: { table_env_var: string, index: string[] }) => {

    logger.info(`Truncating table with event`, event);
    await truncateTable(event.table_env_var, event.index);
    return `Table truncated successfully`;

};
