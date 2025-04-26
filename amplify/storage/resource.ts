import { defineStorage } from '@aws-amplify/backend';
import { importReceiveFunction } from '../function/import/resource';
import { IMPORT_DIR } from '../data/constants';

export const storage = defineStorage({
    name: 'drive',

    versioned: true,

    access: (allow) => ({
        'data/{entity_id}/*': [
            // {entity_id} is the token that is replaced with the user identity id
            allow.entity('identity').to(['read', 'write', 'delete'])
        ],

        [IMPORT_DIR + '*']: [
            allow.resource(importReceiveFunction).to(['read', 'write', 'delete']),
        ],
    })
});