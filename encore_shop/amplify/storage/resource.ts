import { defineStorage } from "@aws-amplify/backend"

export const openSearchBackup = defineStorage({
  name: "opensearch-backup-bucket",
  access: allow => ({
    'public/*': [
      allow.guest.to(['list', 'write', 'get'])
    ]
  })
})

