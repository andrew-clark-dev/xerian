import { a, defineData, type ClientSchema } from '@aws-amplify/backend';
import { importAccountFunction, importItemFunction, importSaleFunction } from './import/resource';
import { initDataFunction } from './init-data/resource';
import { createActionFunction } from './create-action/resource';
import { postConfirmation } from '../auth/post-confirmation/resource';

export const schema = a.schema({

  // Models
  Counter: a
    .model({
      name: a.string().required(),
      val: a.integer().required(),

    })
    .identifier(['name']),

  Total: a
    .model({
      name: a.string().required(),
      val: a.integer().required(),
    })
    .identifier(['name']),

  Action: a
    .model({
      description: a.string().required(),
      actor: a.string(),
      modelName: a.string(),
      refId: a.id(), // Loose coupling for now
      type: a.enum(["Create", "Read", "Update", "Delete", "Search", "Import", "Export", "Increment", "Decrement", "Auth"]),
      typeIndex: a.string().required(),
      userId: a.id(),
      createdBy: a.belongsTo('UserProfile', 'userId'),
      before: a.json(),
      after: a.json(),
    })
    .secondaryIndexes((index) => [index("refId"), index("userId"), index("typeIndex"), index("modelName")]),

  Comment: a
    .model({
      lastActivityBy: a.id().required(),
      text: a.string().required(),
      type: a.string(),
      refId: a.id().required(), // Lose coupling for now
      refType: a.string().required(),
      createdAt: a.datetime(),
      userId: a.id(),
      createdBy: a.belongsTo('UserProfile', 'userId'),
      updatedAt: a.datetime(),
    })
    .secondaryIndexes((index) => [index("refId"), index("userId")])
    .authorization(allow => [allow.owner(), allow.group('Admin'), allow.authenticated().to(['read'])]),

  UserProfile: a
    .model({
      email: a.string(),
      profileOwner: a.string(),
      cognitoName: a.string(), // the cognito name not for display
      nickname: a.string(), // the display name
      phoneNumber: a.string(),
      status: a.enum(["Active", "Inactive", "Suspended", "Pending"]),
      role: a.enum(["Admin", "Manager", "Employee", "Service", "Guest"]),
      photo: a.url(),

      comments: a.hasMany('Comment', 'userId'),
      actions: a.hasMany('Action', 'userId'),

      settings: a.json(),
      deletedAt: a.datetime(),

    })
    .secondaryIndexes((index) => [
      index("cognitoName"),
      index("nickname"),
      index("email"),
    ])
    .authorization((allow) => [
      allow.ownerDefinedIn("profileOwner"),
      allow.group('Admin')
    ]),

  Customer: a
    .model({
      email: a.email().required(),
      name: a.string(),
      sales: a.string().array(), // Sales ids
    })
    .secondaryIndexes((index) => [
      index("email"),
    ])
    .authorization((allow) => [
      allow.ownerDefinedIn("profileOwner"),
      allow.group('Admin')
    ]),


  Account: a
    .model({
      id: a.id(),
      number: a.string().required(),
      lastActivityBy: a.id().required(),
      firstName: a.string(),
      lastName: a.string(),
      email: a.string(),
      phoneNumber: a.string(),
      isMobile: a.boolean().default(false),
      addressLine1: a.string(),
      addressLine2: a.string(),
      city: a.string(),
      state: a.string(),
      postcode: a.string(),
      comunicationPreferences: a.enum(["TextMessage", "Email", "Whatsapp", "None"]),
      status: a.enum(["Active", "Inactive", "Suspended"]),
      kind: a.enum(["Standard", "VIP", "Vender", "Employee", "Customer", "Owner"]),
      defaultSplit: a.integer(),
      items: a.hasMany("Item", "accountNumber"), // setup relationships between main types
      transactions: a.string().array(), // this is the list of transaction ids that this item has been involved in.
      balance: a.integer().default(0),
      noSales: a.integer().default(0),
      noItems: a.integer().default(0),
      lastActivityAt: a.datetime(),
      lastItemAt: a.datetime(),
      lastSettlementAt: a.datetime(),
      tags: a.string().array(),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
      deletedAt: a.datetime(),
    })
    .identifier(['number'])
    .secondaryIndexes((index) => [
      index("id"),
      index("status"),
      index("deletedAt").sortKeys(["number", "createdAt", "balance"]),
    ]),

  ItemStatus: a.enum(['Created', 'Tagged', 'Active', 'Sold', 'ToDonate', 'Donated', 'Parked', 'Returned', 'Expired', 'Lost', 'Stolen', 'Multi', 'Unknown']),

  Item: a
    .model({
      id: a.id(),
      sku: a.string().required(),
      lastActivityBy: a.id().required(),
      title: a.string(),
      account: a.belongsTo("Account", "accountNumber"),
      accountNumber: a.string(),
      category: a.string(),
      brand: a.string(),
      color: a.string(),
      size: a.string(),
      description: a.string(),
      details: a.string(),
      images: a.url().array(), // fields can be arrays,
      condition: a.enum(['AsNew', 'Good', 'Marked', 'Damaged', 'Unknown', 'NotSpecified']),
      split: a.integer(),
      price: a.integer(),
      status: a.ref('ItemStatus'), // this is the status of unique items.
      group: a.hasOne('ItemGroup', 'itemSku'), // this is the group of items that are the same. 
      sales: a.string().array(),
      printedAt: a.datetime(),
      lastSoldAt: a.datetime(),
      lastViewedAt: a.datetime(),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
      deletedAt: a.datetime(),
    })
    .identifier(['sku'])
    .secondaryIndexes((index) => [
      index("id"),
      index("createdAt"),
      index("category"),
      index("brand"),
      index("color"),
      index("size"),
      index("status"),
    ]),

  ItemGroup: a
    .model({
      quantity: a.integer().required(),
      statuses: a.ref('ItemStatus').array(), // for the rare cases where multiple instances of items are sold we use this arrray for tracking.
      itemSku: a.string(),
      item: a.belongsTo('Item', 'itemSku'),
    }),

  ItemCategoryKind: a.enum(['Category', 'Brand', 'Color', 'Size']),

  ItemCategory: a
    .model({
      lastActivityBy: a.id().required(),
      categoryKind: a.ref('ItemCategoryKind').required(),
      kind: a.string().required(),
      name: a.string().required(),
      matchNames: a.string().required(),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
      deletedAt: a.datetime(),
    })
    .identifier(['kind', 'name'])
    .secondaryIndexes((index) => [
      index("matchNames"),
      index("kind"),
    ]),

  SaleItem: a
    .customType({
      sku: a.string().required(),
      title: a.string(),
      category: a.string(),
      brand: a.string(),
      color: a.string(),
      size: a.string(),
      description: a.string(),
      details: a.string(),
      condition: a.enum(['AsNew', 'Good', 'Marked', 'Damaged', 'Unknown', 'NotSpecified']),
      split: a.integer(),
      price: a.integer(),
    }),

  Sale: a
    .model({
      id: a.id().required(),
      number: a.string().required(),
      lastActivityBy: a.id().required(),
      customerEmail: a.string(),
      accountNumber: a.string(), // the account number of the customer if exists     
      status: a.enum(['Pending', 'Finalized', 'Parked', 'Voided']),
      discount: a.ref('Discount'),
      gross: a.integer().required(),
      subTotal: a.integer().required(),
      total: a.integer().required(),
      tax: a.integer().required(), // we only track MWST
      change: a.integer(),
      refund: a.integer(),
      accountTotal: a.integer().required(),
      storeTotal: a.integer().required(),
      transaction: a.id().required(), // tranction id
      items: a.ref('SaleItem').array().required(),
      refundedSale: a.string(),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
    })
    .identifier(['number'])
    .secondaryIndexes((index) => [
      index("transaction"),
      index("refundedSale"),
    ]),

  Discount: a
    .customType({
      label: a.string(),
      value: a.integer(),
    }),

  Transaction: a
    .model({
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
      lastActivityBy: a.id().required(),
      paymentType: a.enum(["Cash", "Card", "GiftCard", "StoreCredit", "Other"]),
      type: a.enum(["Sale", "Refund", "Payout", "Reversal", "TransferIn", "TransferOut"]),
      amount: a.integer().required(),
      tax: a.integer().required(),
      status: a.enum(['Pending', 'Completed', 'Failed']),
      linked: a.string(),  // not currently used

    })
    .secondaryIndexes((index) => [
      index("type"),
    ]),

  Notification: a
    .model({
      id: a.id().required(),
      createdAt: a.datetime().required(),
      type: a.enum(['Failure', 'Success', 'Start', 'Alert', 'Fatal']),
      functionName: a.string().required(),
      pid: a.string().required(),
      message: a.string().required(),
      data: a.json(),
    })
    .identifier(['id', 'createdAt'])
    .secondaryIndexes((index) => [
      index("type").sortKeys(["createdAt"]),
      index("functionName").sortKeys(["createdAt"]),
    ]),

}).authorization(allow => [
  allow.group('Employee'), // default to employee
  allow.resource(importAccountFunction),
  allow.resource(importItemFunction),
  allow.resource(importSaleFunction),
  allow.resource(initDataFunction),
  allow.resource(createActionFunction),
  allow.resource(postConfirmation),
]);

// Used for code completion / highlighting when making requests from frontend
export type Schema = ClientSchema<typeof schema>;

// defines the data resource to be deployed
export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'userPool',
  }
});

