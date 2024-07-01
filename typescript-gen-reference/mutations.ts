/* tslint:disable */
/* eslint-disable */
// this is an auto generated file. This will be overwritten

import * as APITypes from "./API";
type GeneratedMutation<InputType, OutputType> = string & {
  __generatedMutationInput: InputType;
  __generatedMutationOutput: OutputType;
};

export const createAccount = /* GraphQL */ `mutation CreateAccount(
  $condition: ModelAccountConditionInput
  $input: CreateAccountInput!
) {
  createAccount(condition: $condition, input: $input) {
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
` as GeneratedMutation<
  APITypes.CreateAccountMutationVariables,
  APITypes.CreateAccountMutation
>;
export const createDashboard = /* GraphQL */ `mutation CreateDashboard(
  $condition: ModelDashboardConditionInput
  $input: CreateDashboardInput!
) {
  createDashboard(condition: $condition, input: $input) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateDashboardMutationVariables,
  APITypes.CreateDashboardMutation
>;
export const createLogin = /* GraphQL */ `mutation CreateLogin(
  $condition: ModelLoginConditionInput
  $input: CreateLoginInput!
) {
  createLogin(condition: $condition, input: $input) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateLoginMutationVariables,
  APITypes.CreateLoginMutation
>;
export const createSettings = /* GraphQL */ `mutation CreateSettings(
  $condition: ModelSettingsConditionInput
  $input: CreateSettingsInput!
) {
  createSettings(condition: $condition, input: $input) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateSettingsMutationVariables,
  APITypes.CreateSettingsMutation
>;
export const createSyncInfo = /* GraphQL */ `mutation CreateSyncInfo(
  $condition: ModelSyncInfoConditionInput
  $input: CreateSyncInfoInput!
) {
  createSyncInfo(condition: $condition, input: $input) {
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
` as GeneratedMutation<
  APITypes.CreateSyncInfoMutationVariables,
  APITypes.CreateSyncInfoMutation
>;
export const deleteAccount = /* GraphQL */ `mutation DeleteAccount(
  $condition: ModelAccountConditionInput
  $input: DeleteAccountInput!
) {
  deleteAccount(condition: $condition, input: $input) {
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
` as GeneratedMutation<
  APITypes.DeleteAccountMutationVariables,
  APITypes.DeleteAccountMutation
>;
export const deleteDashboard = /* GraphQL */ `mutation DeleteDashboard(
  $condition: ModelDashboardConditionInput
  $input: DeleteDashboardInput!
) {
  deleteDashboard(condition: $condition, input: $input) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteDashboardMutationVariables,
  APITypes.DeleteDashboardMutation
>;
export const deleteLogin = /* GraphQL */ `mutation DeleteLogin(
  $condition: ModelLoginConditionInput
  $input: DeleteLoginInput!
) {
  deleteLogin(condition: $condition, input: $input) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteLoginMutationVariables,
  APITypes.DeleteLoginMutation
>;
export const deleteSettings = /* GraphQL */ `mutation DeleteSettings(
  $condition: ModelSettingsConditionInput
  $input: DeleteSettingsInput!
) {
  deleteSettings(condition: $condition, input: $input) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteSettingsMutationVariables,
  APITypes.DeleteSettingsMutation
>;
export const deleteSyncInfo = /* GraphQL */ `mutation DeleteSyncInfo(
  $condition: ModelSyncInfoConditionInput
  $input: DeleteSyncInfoInput!
) {
  deleteSyncInfo(condition: $condition, input: $input) {
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
` as GeneratedMutation<
  APITypes.DeleteSyncInfoMutationVariables,
  APITypes.DeleteSyncInfoMutation
>;
export const publishServerEventToEventBridge = /* GraphQL */ `mutation PublishServerEventToEventBridge(
  $eventId: ID!
  $eventType: String!
  $modelType: String!
  $payload: String!
) {
  publishServerEventToEventBridge(
    eventId: $eventId
    eventType: $eventType
    modelType: $modelType
    payload: $payload
  ) {
    eventId
    eventType
    modelType
    payload
    __typename
  }
}
` as GeneratedMutation<
  APITypes.PublishServerEventToEventBridgeMutationVariables,
  APITypes.PublishServerEventToEventBridgeMutation
>;
export const updateAccount = /* GraphQL */ `mutation UpdateAccount(
  $condition: ModelAccountConditionInput
  $input: UpdateAccountInput!
) {
  updateAccount(condition: $condition, input: $input) {
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
` as GeneratedMutation<
  APITypes.UpdateAccountMutationVariables,
  APITypes.UpdateAccountMutation
>;
export const updateDashboard = /* GraphQL */ `mutation UpdateDashboard(
  $condition: ModelDashboardConditionInput
  $input: UpdateDashboardInput!
) {
  updateDashboard(condition: $condition, input: $input) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateDashboardMutationVariables,
  APITypes.UpdateDashboardMutation
>;
export const updateLogin = /* GraphQL */ `mutation UpdateLogin(
  $condition: ModelLoginConditionInput
  $input: UpdateLoginInput!
) {
  updateLogin(condition: $condition, input: $input) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateLoginMutationVariables,
  APITypes.UpdateLoginMutation
>;
export const updateSettings = /* GraphQL */ `mutation UpdateSettings(
  $condition: ModelSettingsConditionInput
  $input: UpdateSettingsInput!
) {
  updateSettings(condition: $condition, input: $input) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateSettingsMutationVariables,
  APITypes.UpdateSettingsMutation
>;
export const updateSyncInfo = /* GraphQL */ `mutation UpdateSyncInfo(
  $condition: ModelSyncInfoConditionInput
  $input: UpdateSyncInfoInput!
) {
  updateSyncInfo(condition: $condition, input: $input) {
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
` as GeneratedMutation<
  APITypes.UpdateSyncInfoMutationVariables,
  APITypes.UpdateSyncInfoMutation
>;
