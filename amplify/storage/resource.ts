import { defineFunction, defineStorage } from "@aws-amplify/backend";

export const storage = defineStorage({
  name: 'appFiles',
  access: (allow) => ({
    'import/account/*': [
      allow.authenticated.to(['write'])
    ],
  }),
  triggers: {
    onUpload: defineFunction({
      entry: './on-upload-handler.ts'
    })
  }
});