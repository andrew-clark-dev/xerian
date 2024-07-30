import { type ClientSchema, a, defineData } from "@aws-amplify/backend";
import { addUserToGroup } from "./add-user-to-group/resource"
import { generateClient } from "aws-amplify/api";

const schema = a.schema({

  // Models
  Account: a
    .model({
      number: a.integer().required(),
      firstName: a.string(),
      lastName: a.string(),
      email: a.string(),
      phoneNumber: a.string(),
      isMobile: a.boolean().default(false),
      address: a.string(), // Multiline string,
      city: a.string(),
      state: a.string(),
      postcode: a.string(),
      balance: a.float().required(),
      comunicationPreferences: a.enum(["sms", "email", "none", "all"]),
      status: a.enum(["active", "inactive", "suspended"]),
      vip: a.enum(["vip", "none"]),
      comment: a.string(),
      metadata: a.json(),
    })
    .secondaryIndexes((index) => [index("number")]),

  // Functions
  addUserToGroup: a
    .mutation()
    .arguments({
      userId: a.string().required(),
      groupName: a.string().required(),
    })
    .authorization((allow) => [allow.groups(["Admin"])])
    .handler(a.handler.function(addUserToGroup))
    .returns(a.json()),
})


  // Default is to allow access to authenticated users
  .authorization((allow) => [allow.authenticated()]);

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: "userPool",
  },
});
