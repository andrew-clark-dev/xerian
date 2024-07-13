/* tslint:disable */
/* eslint-disable */
// this is an auto generated file. This will be overwritten

import * as APITypes from "./API";
type GeneratedSubscription<InputType, OutputType> = string & {
  __generatedSubscriptionInput: InputType;
  __generatedSubscriptionOutput: OutputType;
};

export const onCreateAccount = /* GraphQL */ `subscription OnCreateAccount($filter: ModelSubscriptionAccountFilterInput) {
  onCreateAccount(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateAccountSubscriptionVariables,
  APITypes.OnCreateAccountSubscription
>;
export const onCreateDashboard = /* GraphQL */ `subscription OnCreateDashboard($filter: ModelSubscriptionDashboardFilterInput) {
  onCreateDashboard(filter: $filter) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedSubscription<
  APITypes.OnCreateDashboardSubscriptionVariables,
  APITypes.OnCreateDashboardSubscription
>;
export const onCreateLogin = /* GraphQL */ `subscription OnCreateLogin($filter: ModelSubscriptionLoginFilterInput) {
  onCreateLogin(filter: $filter) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedSubscription<
  APITypes.OnCreateLoginSubscriptionVariables,
  APITypes.OnCreateLoginSubscription
>;
export const onCreateSettings = /* GraphQL */ `subscription OnCreateSettings($filter: ModelSubscriptionSettingsFilterInput) {
  onCreateSettings(filter: $filter) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedSubscription<
  APITypes.OnCreateSettingsSubscriptionVariables,
  APITypes.OnCreateSettingsSubscription
>;
export const onCreateSyncInfo = /* GraphQL */ `subscription OnCreateSyncInfo($filter: ModelSubscriptionSyncInfoFilterInput) {
  onCreateSyncInfo(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateSyncInfoSubscriptionVariables,
  APITypes.OnCreateSyncInfoSubscription
>;
export const onDeleteAccount = /* GraphQL */ `subscription OnDeleteAccount($filter: ModelSubscriptionAccountFilterInput) {
  onDeleteAccount(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteAccountSubscriptionVariables,
  APITypes.OnDeleteAccountSubscription
>;
export const onDeleteDashboard = /* GraphQL */ `subscription OnDeleteDashboard($filter: ModelSubscriptionDashboardFilterInput) {
  onDeleteDashboard(filter: $filter) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedSubscription<
  APITypes.OnDeleteDashboardSubscriptionVariables,
  APITypes.OnDeleteDashboardSubscription
>;
export const onDeleteLogin = /* GraphQL */ `subscription OnDeleteLogin($filter: ModelSubscriptionLoginFilterInput) {
  onDeleteLogin(filter: $filter) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedSubscription<
  APITypes.OnDeleteLoginSubscriptionVariables,
  APITypes.OnDeleteLoginSubscription
>;
export const onDeleteSettings = /* GraphQL */ `subscription OnDeleteSettings($filter: ModelSubscriptionSettingsFilterInput) {
  onDeleteSettings(filter: $filter) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedSubscription<
  APITypes.OnDeleteSettingsSubscriptionVariables,
  APITypes.OnDeleteSettingsSubscription
>;
export const onDeleteSyncInfo = /* GraphQL */ `subscription OnDeleteSyncInfo($filter: ModelSubscriptionSyncInfoFilterInput) {
  onDeleteSyncInfo(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteSyncInfoSubscriptionVariables,
  APITypes.OnDeleteSyncInfoSubscription
>;
export const onUpdateAccount = /* GraphQL */ `subscription OnUpdateAccount($filter: ModelSubscriptionAccountFilterInput) {
  onUpdateAccount(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateAccountSubscriptionVariables,
  APITypes.OnUpdateAccountSubscription
>;
export const onUpdateDashboard = /* GraphQL */ `subscription OnUpdateDashboard($filter: ModelSubscriptionDashboardFilterInput) {
  onUpdateDashboard(filter: $filter) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedSubscription<
  APITypes.OnUpdateDashboardSubscriptionVariables,
  APITypes.OnUpdateDashboardSubscription
>;
export const onUpdateLogin = /* GraphQL */ `subscription OnUpdateLogin($filter: ModelSubscriptionLoginFilterInput) {
  onUpdateLogin(filter: $filter) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedSubscription<
  APITypes.OnUpdateLoginSubscriptionVariables,
  APITypes.OnUpdateLoginSubscription
>;
export const onUpdateSettings = /* GraphQL */ `subscription OnUpdateSettings($filter: ModelSubscriptionSettingsFilterInput) {
  onUpdateSettings(filter: $filter) {
    config
    createdAt
    email
    id
    updatedAt
    __typename
  }
}
` as GeneratedSubscription<
  APITypes.OnUpdateSettingsSubscriptionVariables,
  APITypes.OnUpdateSettingsSubscription
>;
export const onUpdateSyncInfo = /* GraphQL */ `subscription OnUpdateSyncInfo($filter: ModelSubscriptionSyncInfoFilterInput) {
  onUpdateSyncInfo(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateSyncInfoSubscriptionVariables,
  APITypes.OnUpdateSyncInfoSubscription
>;
