import { defineFunction, secret } from "@aws-amplify/backend";


export const IMPORT_DIRS = {
    IN_DIR: 'import/in/',
    PROCESSING_DIR: 'import/processing/',
    ARCHIVE_DIR: 'import/archive/',
    ERROR_DIR: 'import/error/',
}

export const importItemFunction = defineFunction({
    name: "import-item-function",
    entry: "./handler.item.ts",
    resourceGroupName: "data",
    timeoutSeconds: 30,
    environment: {
        ...IMPORT_DIRS,
        SERVICE_NAME: "import-item-function"
    },
});

export const importReceiveFunction = defineFunction({
    name: "import-receive-function",
    entry: "./handler.receive.ts",
    resourceGroupName: "data",
    timeoutSeconds: 900,
    environment: {
        ...IMPORT_DIRS,
        MAX_LINES: "1000",
        SERVICE_NAME: "import-receive-function",
        API_KEY: secret('api-key')
    },
});