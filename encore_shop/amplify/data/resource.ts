import { type ClientSchema, a, defineData } from "@aws-amplify/backend";

/*== STEP 1 ===============================================================
The section below creates a Todo database table with a "content" field. Try
adding a new "isDone" field as a boolean. The authorization rule below
specifies that any unauthenticated user can "create", "read", "update", 
and "delete" any "Todo" records.
=========================================================================*/
const schema = a.schema({
  Counter: a
    .model({
      count: a.integer(),
    })
    .authorization((allow) => [allow.authenticated()]),
    Account: a
    .model({
      number: a.integer().required(),
      firstName: a.string().required(),
      lastName: a.string(),
      email: a.email(),
      phoneNumber: a.phone(),
      address: a.string().array(), // fields can be arrays,
      city: a.string(),
      state: a.string(),
      postcode: a.string(),
      split: a.integer(),
      items: a.hasMany("Item", "accountId"), // setup relationships between types
    })
    .authorization((allow) => [allow.authenticated()]),

    Item: a
    .model({
      sku: a.integer().required(),
      accountId: a.id(),
      account: a.belongsTo("Account", "accountId"), 
      categories: a.hasMany("ItemCategory", "itemId"),
      description: a.string().required(),
      details: a.string(),
      images: a.url().array(), // fields can be arrays,
      quality: a.enum(['AS_NEW','GOOD', 'MARKED']),
      split: a.integer(),
      status: a.enum(['TAGGED','HUNG_OUT', 'SOLD', 'TO_DONATE', 'DONATED']),
    })
    .authorization((allow) => [allow.authenticated()]),
    
    searchAccounts: a
    .query()
    .returns(a.ref("Account").array())
    .authorization((allow) => [allow.publicApiKey()])
    .handler(
      a.handler.custom({
        entry: "./searchAccountResolver.js",
        dataSource: "osDataSource",
      })
    ),

    ItemCategory: a.model({
      // 1. Create reference fields to both ends of
      //    the many-to-many relationship
      itemId: a.id().required(),
      categoryId: a.id().required(),
      // 2. Create relationship fields to both ends of
      //    the many-to-many relationship using their
      //    respective reference fields
      item: a.belongsTo('Item', 'itemId'),
      category: a.belongsTo('Category', 'categoryId'),
    }),

    Category: a
    .model({
      type: a.enum(['DEPARTMENT','COLOUR', 'BRAND', 'SIZE']),
      items: a.hasMany("ItemCategory", "categoryId"), 
      value: a.string(),
    })
    .secondaryIndexes((index) => [index("type")])
    .authorization((allow) => [allow.authenticated()]),


    Sale: a
    .model({
      number: a.integer(),
      status: a.enum(['PARKED','FINALIZED']),
      finalized: a.datetime(),
      total: a.float(),
      subtotal: a.float(),
      paymentType: a.enum(['CASH','CARD', 'GIFT_CARD', 'ACCOUNT_CREDIT'])
    })
    .authorization((allow) => [allow.authenticated()]),

    Refund: a
    .model({
      number: a.integer(),
      status: a.enum(['PARKED','FINALIZED']),
      finalized: a.datetime(),
      total: a.float(),
      subtotal: a.float(),
      paymentType: a.enum(['CASH'])
    })
    .authorization((allow) => [allow.authenticated()]),


    Journal: a
    .model({
      modelId: a.id().required(),
      timestamp: a.datetime().required(),
      action: a.string(),
      before: a.json(),
      after: a.json()
    })
    .authorization((allow) => [allow.authenticated()]),

    Tag: a
    .model({
      modelId: a.id(),
      key: a.string(),
      value: a.string(),
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
    .authorization((allow) => [allow.authenticated()])
    .handler(a.handler.custom({
      dataSource: a.ref('Counter'),
      entry: './increment-counter.js'
    })),
}).authorization((allow) => [allow.authenticated()]);

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: "userPool",
  },
});

/*== STEP 2 ===============================================================
Go to your frontend source code. From your client-side code, generate a
Data client to make CRUDL requests to your table. (THIS SNIPPET WILL ONLY
WORK IN THE FRONTEND CODE FILE.)

Using JavaScript or Next.js React Server Components, Middleware, Server 
Actions or Pages Router? Review how to generate Data clients for those use
cases: https://docs.amplify.aws/gen2/build-a-backend/data/connect-to-API/
=========================================================================*/

/*
"use client"
import { generateClient } from "aws-amplify/data";
import type { Schema } from "@/amplify/data/resource";

const client = generateClient<Schema>() // use this Data client for CRUDL requests
*/

/*== STEP 3 ===============================================================
Fetch records from the database and use them in your frontend component.
(THIS SNIPPET WILL ONLY WORK IN THE FRONTEND CODE FILE.)
=========================================================================*/

/* For example, in a React component, you can use this snippet in your
  function's RETURN statement */
// const { data: todos } = await client.models.Todo.list()

// return <ul>{todos.map(todo => <li key={todo.id}>{todo.content}</li>)}</ul>
