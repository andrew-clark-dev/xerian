import { defineStorage } from '@aws-amplify/backend';
import { IMPORT_DIRS, importReceiveFunction } from '../function/import/resource';

export const storage = defineStorage({
    name: 'drive',

    versioned: true,

    access: (allow) => ({
        'data/{entity_id}/*': [
            // {entity_id} is the token that is replaced with the user identity id
            allow.entity('identity').to(['read', 'write', 'delete'])
        ],

        [IMPORT_DIRS.IN_DIR + '*']: [
            allow.resource(importReceiveFunction).to(['read', 'write', 'delete']),
        ],
        [IMPORT_DIRS.PROCESSING_DIR + '*']: [
            allow.resource(importReceiveFunction).to(['write']),
        ],
        // [IMPORT_DIRS.ARCHIVE_DIR + '*']: [
        //     allow.resource(importReceiveFunction).to(['write']),
        // ],
        [IMPORT_DIRS.ERROR_DIR + '*']: [
            allow.resource(importReceiveFunction).to(['write']),
        ]
    })
});