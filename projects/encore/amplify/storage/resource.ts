import { defineStorage } from '@aws-amplify/backend';

export const storage = defineStorage({
    name: 'encoreFiles',
    access: (allow) => ({
        'uploads/import/*': [
            allow.groups(['SuperUser']).to(['read', 'write'])
        ],
    })
});