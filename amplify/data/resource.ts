import { type ClientSchema, a, defineData } from "@aws-amplify/backend";

const schema = a.schema({

  // Models
  Login: a
    .model({
      email: a.email(),
      config: a.json(),
    }),

  Dashboard: a
    .model({
      email: a.email(),
      config: a.json(),
    }),

  Settings: a
    .model({
      email: a.email(),
      config: a.json(),
    }),

  publishRequest: a
    .mutation()
    .arguments({
      source: a.string().required(),
      payload: a.string().required(),
    })
    .returns(a.json())
    .authorization((allow) => [allow.authenticated()])
    .handler(a.handler.custom({
      dataSource: "EventBridgeDataSource",
      entry: './publishRequest.js'
    })),

  SyncInfo: a
    .model({
      modelType: a.string(),
      user: a.string(),
      timestamp: a.datetime(),
      info: a.json(),
    }),

  Account: a
    .model({
      number: a.string().required(),
      firstName: a.string().required(),
      lastName: a.string(),
      email: a.string(),
      phoneNumber: a.string(),
      isMobile: a.boolean().default(false),
      address: a.string(), // Multiline string,
      city: a.string(),
      state: a.string(),
      postcode: a.string(),
      balance: a.float(),
      comunicationPreferences: a.enum(["sms", "email", "none", "all"]),
      status: a.enum(["active", "inactive", "suspended"]),
      original: a.json(),
    })
    .secondaryIndexes((index) => [index("number")]),
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