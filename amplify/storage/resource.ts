import { defineStorage } from '@aws-amplify/backend';
import { IMPORT_DIRS, importAccountFunction, importItemFunction, importReceiveFunction, importSaleFunction } from '../data/import/resource';

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
            allow.resource(importReceiveFunction).to(['read', 'write', 'delete']),
            allow.resource(importAccountFunction).to(['read', 'write', 'delete']),
            allow.resource(importItemFunction).to(['read', 'write', 'delete']),
            allow.resource(importSaleFunction).to(['read', 'write', 'delete']),
        ],
        [IMPORT_DIRS.ARCHIVE_DIR + '*']: [
            allow.resource(importReceiveFunction).to(['write']),
            allow.resource(importAccountFunction).to(['write']),
            allow.resource(importItemFunction).to(['write']),
            allow.resource(importSaleFunction).to(['write']),
        ],
        [IMPORT_DIRS.ERROR_DIR + '*']: [
            allow.resource(importReceiveFunction).to(['write']),
            allow.resource(importAccountFunction).to(['write']),
            allow.resource(importItemFunction).to(['write']),
            allow.resource(importSaleFunction).to(['write']),
        ]
    })
});