import { defineFunction } from '@aws-amplify/backend';
export const importAccountCsv = defineFunction({
    // optionally specify a name for the Function (defaults to directory name)
    name: 'import-account-csv',
    // optionally specify a path to your handler (defaults to "./handler.ts")
    entry: './handler.ts',
    // 5 minute timeout
    timeoutSeconds: 300,
    // define the lastest supported runtime
    runtime: 20,
});
