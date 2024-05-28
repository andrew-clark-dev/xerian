import { defineStorage } from "@aws-amplify/backend";

import { importAccountCsv } from '../functions/import/resource';

export const storage = defineStorage({
  name: 'appFiles',
  access: (allow) => ({
    'import/account/*': [
      allow.authenticated.to(['write'])
    ],
  }),
  triggers: { onUpload: importAccountCsv }
});