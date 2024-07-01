import { defineFunction } from '@aws-amplify/backend';

export const uiEvent = defineFunction({
    // optionally specify a name for the Function (defaults to directory name)
    name: 'ui-event',
    // optionally specify a path to your handler (defaults to "./handler.ts")
    entry: './handler.ts'
});