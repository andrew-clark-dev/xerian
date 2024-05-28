import { defineStorage } from "@aws-amplify/backend";

import { importAccountCsv } from '../functions/import/resource';

export const storage = defineStorage({
  name: 'appFiles',
  access: (allow) => ({
    'import/account/*': [
      allow.authenticated.to(['write']),
      allow.resource(importAccountCsv).to(['read', 'write', 'delete'])
    ]
  }),
  triggers: { onUpload: importAccountCsv }
});


