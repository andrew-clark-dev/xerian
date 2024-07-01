import { Amplify } from 'aws-amplify';
import outputs from './amplify_outputs.json';

Amplify.configure(outputs);
const existingConfig = Amplify.getConfig();
const x = {
    ...existingConfig,
    API: {
        ...existingConfig.API,
        REST: outputs.custom.API,
    },
}
Amplify.configure({
    ...existingConfig,
    API: {
        ...existingConfig.API,
        REST: outputs.custom.API,
    },
});

console.log(outputs);