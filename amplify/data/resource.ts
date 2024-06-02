import { type ClientSchema, a, defineData } from "@aws-amplify/backend";

const schema = a.schema({

  // Models

  Counter: a
    .model({
      count: a.integer(),
    })
    .authorization((allow) => [allow.authenticated()]),
  Account: a
    .model({
      number: a.string().required(),
      firstName: a.string().required(),
      lastName: a.string(),
      email: a.string(),
      phoneNumber: a.string(),
      address: a.string(), // Multiline string,
      city: a.string(),
      state: a.string(),
      postcode: a.string(),
      balance: a.float(),
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
    }),

  Item: a
    .model({
      sku: a.integer().required(),
      // accountId: a.id(),
      // account: a.belongsTo("Account", "accountId"),
      categories: a.hasMany("ItemCategory", "itemId"),
      description: a.string().required(),
      details: a.string(),
      images: a.url().array(), // fields can be arrays,
      quality: a.enum(["asNew", "good", "marked"]),
      split: a.integer(),
      status: a.enum(["tagged", "hungOut", "sold", "toDonate", "donated"]),
      original: a.json(),
    }),

  ItemCategory: a.model({
    // 1. Create reference fields to both ends of
    //    the many-to-many relationship
    itemId: a.id().required(),
    categoryId: a.id().required(),
    // 2. Create relationship fields to both ends of
    //    the many-to-many relationship using their
    //    respective reference fields
    item: a.belongsTo("Item", "itemId"),
    category: a.belongsTo("Category", "categoryId"),
  }),

  Category: a
    .model({
      type: a.enum(["department", "colour", "brand", "size"]),
      items: a.hasMany("ItemCategory", "categoryId"),
      value: a.string(),
    })
    .secondaryIndexes((index) => [index("type")]),

  Sale: a
    .model({
      number: a.integer(),
      status: a.enum(["parked", "finalized"]),
      finalized: a.datetime(),
      total: a.float(),
      subtotal: a.float(),
      paymentType: a.enum(["cash", "card", "giftCard", "accountCredit"]),
      original: a.json(),
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

  //Custom Queries/Modifcations

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