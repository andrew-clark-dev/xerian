import { type ClientSchema, a, defineData } from "@aws-amplify/backend";
import { addUserToGroup } from "./add-user-to-group/resource"
import { generateClient } from "aws-amplify/api";

const schema = a.schema({

  // Models
  Account: a
    .model({
      number: a.string().required(),
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
      comunicationPreferences: a.enum(["SMS", "EMAIL", "NONE", "ALL"]),
      status: a.enum(["ACTIVE", "INACTIVE", "SUSPENDED"]),
      category: a.enum(["VIP", "VENDER", "STANDARD", "EMPLOYEE"]),
      comment: a.string(),
      items: a.hasMany("Item", "accountId"), // setup relationships between types
      metadata: a.json(),
      active: a.boolean().default(true),
      updatedAt: a.datetime(),
    })
    .secondaryIndexes((index) => [index("number")]),

  Item: a
    .model({
      sku: a.string().required(),
      title: a.string(),
      accountId: a.id(),
      account: a.belongsTo("Account", "accountId"),
      accountNumber: a.string(),
      category: a.string().required(),
      brand: a.string(),
      color: a.string(),
      size: a.string(),
      description: a.string(),
      details: a.string(),
      images: a.url().array(), // fields can be arrays,
      condition: a.enum(['AS_NEW', 'GOOD', 'MARKED', 'DAMAGED', 'UNKNOWN']),
      quantity: a.integer().required(),
      split: a.integer().required(),
      price: a.float().required(),
      status: a.enum(['TAGGED', 'HUNG_OUT', 'SOLD', 'TO_DONATE', 'DONATED', 'PARKED', 'RETURNED']),
      printedAt: a.datetime(),
      metadata: a.json(),
      active: a.boolean().default(true),
      updatedAt: a.datetime(),
    })
    .secondaryIndexes((index) => [index("sku"), index("accountId")]),

  Category: a
    .model({
      name: a.string().required(),
      alt: a.string().array(),
      metadata: a.json(),
      active: a.boolean().default(true),
      updatedAt: a.datetime(),
    })
    .identifier(['name']),

  Brand: a
    .model({
      name: a.string().required(),
      alt: a.string().array(),
      metadata: a.json(),
      active: a.boolean().default(true),
      updatedAt: a.datetime(),
    })
    .identifier(['name']),

  Color: a
    .model({
      name: a.string().required(),
      alt: a.string().array(),
      metadata: a.json(),
      active: a.boolean().default(true),
      updatedAt: a.datetime(),
    })
    .identifier(['name']),

  Size: a
    .model({
      name: a.string().required(),
      alt: a.string().array(),
      metadata: a.json(),
      active: a.boolean().default(true),
      updatedAt: a.datetime(),
    })
    .identifier(['name']),

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
