import { type ClientSchema, a, defineData } from "@aws-amplify/backend";

const schema = a.schema({

  // Models

  Counter: a
    .model({
      count: a.integer(),
    })
    .authorization((allow) => [allow.authenticated()]),


  incrementCounter: a
    .mutation()
    // arguments that this query accepts
    .arguments({
      id: a.id(),
    })
    // return type of the query
    .returns(a.ref("Counter"))
    // only allow signed-in users to call this API
    .handler(
      a.handler.custom({
        dataSource: a.ref("Counter"),
        entry: "./increment-counter.js",
      })
    ),

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
      adprefs: a.enum(["promoSms", "none", "all"]),
      status: a.enum(["active", "inactive", "suspended"]),
      original: a.json(),
      // 1. Create reference fields to both ends of
      //    the many-to-many relationship
      // items: a.hasMany("Item", "accountId"),
      // sales: a.hasMany("Sale", "accountId"),
      // refunds: a.hasMany("Refund", "accountId"),
      // 2. Create relationship fields to both ends of
      //    the many-to-many relationship using their
      //    respective reference fields
      // items: a.hasMany("Item", "accountId"), // setup relationships between types
    })
    .secondaryIndexes((index) => [index("number")]),

  searchAccounts: a
    .query()
    .arguments({ matchString: a.string() })
    .returns(a.ref("Account").array())
    .handler(
      a.handler.custom({
        entry: "./searchAccountResolver.js",
        dataSource: "osDataSource",
      })
    ),

  Item: a
    .model({
      sku: a.integer().required(),
      account: a.string(),
      deparment: a.string(),
      brand: a.string(),
      color: a.string(),
      size: a.string(),
      description: a.string().required(),
      details: a.string(),
      images: a.url().array(), // fields can be arrays,
      quality: a.enum(["asNew", "good", "marked"]),
      split: a.integer(),
      status: a.enum(["tagged", "hungOut", "sold", "toDonate", "donated"]),
      original: a.json(),
    }),

  searchItems: a
    .query()
    .arguments({ matchString: a.string() })
    .returns(a.ref("Item").array())
    .handler(
      a.handler.custom({
        entry: "./searchItemResolver.js",
        dataSource: "osDataSource",
      })
    ),

  Sale: a
    .model({
      number: a.integer().required(),
      item: a.string().required(),
      account: a.string().required(),
      status: a.enum(["parked", "finalized"]),
      finalized: a.datetime(),
      total: a.float(),
      subtotal: a.float(),
      paymentType: a.enum(["cash", "card", "giftCard", "accountCredit"]),
      original: a.json(),
    }),

  searchSales: a
    .query()
    .arguments({ matchString: a.string() })
    .returns(a.ref("Sale").array())
    .handler(
      a.handler.custom({
        entry: "./searchSaleResolver.js",
        dataSource: "osDataSource",
      })
    ),

  Group: a
    .model({
      type: a.enum(["category", "color", "brand", "size"]),
      value: a.string().required(),
      alternatives: a.string().array(),
    }),

  Refund: a
    .model({
      number: a.integer(),
      status: a.enum(["parked", "finalized"]),
      finalized: a.datetime(),
      total: a.float(),
      subtotal: a.float(),
      paymentType: a.enum(["cash", "accountCredit"]),
    }),

  Journal: a
    .model({
      modelId: a.id().required(),
      timestamp: a.datetime().required(),
      action: a.string(),
      before: a.json(),
      after: a.json(),
    }),

  Tag: a
    .model({
      modelId: a.id(),
      key: a.string(),
      value: a.string(),
    }),

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