/* tslint:disable */
/* eslint-disable */
// this is an auto generated file. This will be overwritten

import * as APITypes from "./API";
type GeneratedQuery<InputType, OutputType> = string & {
  __generatedQueryInput: InputType;
  __generatedQueryOutput: OutputType;
};

export const getAccount = /* GraphQL */ `query GetAccount($id: ID!) {
  getAccount(id: $id) {
    address
    balance
    city
    comunicationPreferences
    createdAt
    email
    firstName
    id
    isMobile
    lastName
    number
    original
    phoneNumber
    postcode
    state
    status
    updatedAt
    __typename
  }
}
` as GeneratedQuery<
  APITypes.GetAccountQueryVariables,
  APITypes.GetAccountQuery
>;
export const getDashboard = /* GraphQL */ `query GetDashboard($id: ID!) {
  getDashboard(id: $id) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedQuery<
  APITypes.GetDashboardQueryVariables,
  APITypes.GetDashboardQuery
>;
export const getLogin = /* GraphQL */ `query GetLogin($id: ID!) {
  getLogin(id: $id) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedQuery<APITypes.GetLoginQueryVariables, APITypes.GetLoginQuery>;
export const getSettings = /* GraphQL */ `query GetSettings($id: ID!) {
  getSettings(id: $id) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedQuery<
  APITypes.GetSettingsQueryVariables,
  APITypes.GetSettingsQuery
>;
export const getSyncInfo = /* GraphQL */ `query GetSyncInfo($id: ID!) {
  getSyncInfo(id: $id) {
    createdAt
    id
    info
    modelType
    timestamp
    updatedAt
    user
    __typename
  }
}
` as GeneratedQuery<
  APITypes.GetSyncInfoQueryVariables,
  APITypes.GetSyncInfoQuery
>;
export const listAccountByNumber = /* GraphQL */ `query ListAccountByNumber(
  $filter: ModelAccountFilterInput
  $limit: Int
  $nextToken: String
  $number: String!
  $sortDirection: ModelSortDirection
) {
  listAccountByNumber(
    filter: $filter
    limit: $limit
    nextToken: $nextToken
    number: $number
    sortDirection: $sortDirection
  ) {
    items {
      address
      balance
      city
      comunicationPreferences
      createdAt
      email
      firstName
      id
      isMobile
      lastName
      number
      original
      phoneNumber
      postcode
      state
      status
      updatedAt
      __typename
    }
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListAccountByNumberQueryVariables,
  APITypes.ListAccountByNumberQuery
>;
export const listAccounts = /* GraphQL */ `query ListAccounts(
  $filter: ModelAccountFilterInput
  $limit: Int
  $nextToken: String
) {
  listAccounts(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
      address
      balance
      city
      comunicationPreferences
      createdAt
      email
      firstName
      id
      isMobile
      lastName
      number
      original
      phoneNumber
      postcode
      state
      status
      updatedAt
      __typename
    }
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListAccountsQueryVariables,
  APITypes.ListAccountsQuery
>;
export const listDashboards = /* GraphQL */ `query ListDashboards(
  $filter: ModelDashboardFilterInput
  $limit: Int
  $nextToken: String
) {
  listDashboards(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
      config
      createdAt
      email
      id
      updatedAt
      __typename
    }
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListDashboardsQueryVariables,
  APITypes.ListDashboardsQuery
>;
export const listLogins = /* GraphQL */ `query ListLogins(
  $filter: ModelLoginFilterInput
  $limit: Int
  $nextToken: String
) {
  listLogins(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
      config
      createdAt
      email
      id
      updatedAt
      __typename
    }
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListLoginsQueryVariables,
  APITypes.ListLoginsQuery
>;
export const listSettings = /* GraphQL */ `query ListSettings(
  $filter: ModelSettingsFilterInput
  $limit: Int
  $nextToken: String
) {
  listSettings(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
      config
      createdAt
      email
      id
      updatedAt
      __typename
    }
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListSettingsQueryVariables,
  APITypes.ListSettingsQuery
>;
export const listSyncInfos = /* GraphQL */ `query ListSyncInfos(
  $filter: ModelSyncInfoFilterInput
  $limit: Int
  $nextToken: String
) {
  listSyncInfos(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
      createdAt
      id
      info
      modelType
      timestamp
      updatedAt
      user
      __typename
    }
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListSyncInfosQueryVariables,
  APITypes.ListSyncInfosQuery
>;
