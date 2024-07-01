/* tslint:disable */
/* eslint-disable */
//  This file was automatically generated and should not be edited.

export type Account = {
  __typename: "Account",
  address?: string | null,
  balance?: number | null,
  city?: string | null,
  comunicationPreferences?: AccountComunicationPreferences | null,
  createdAt: string,
  email?: string | null,
  firstName: string,
  id: string,
  isMobile?: boolean | null,
  lastName?: string | null,
  number: string,
  original?: string | null,
  phoneNumber?: string | null,
  postcode?: string | null,
  state?: string | null,
  status?: AccountStatus | null,
  updatedAt: string,
};

export enum AccountComunicationPreferences {
  all = "all",
  email = "email",
  none = "none",
  sms = "sms",
}


export enum AccountStatus {
  active = "active",
  inactive = "inactive",
  suspended = "suspended",
}


export type Dashboard = {
  __typename: "Dashboard",
  config?: string | null,
  createdAt: string,
  email?: string | null,
  id: string,
  updatedAt: string,
};

export type Login = {
  __typename: "Login",
  config?: string | null,
  createdAt: string,
  email?: string | null,
  id: string,
  updatedAt: string,
};

export type Settings = {
  __typename: "Settings",
  config?: string | null,
  createdAt: string,
  email?: string | null,
  id: string,
  updatedAt: string,
};

export type SyncInfo = {
  __typename: "SyncInfo",
  createdAt: string,
  id: string,
  info?: string | null,
  modelType?: string | null,
  timestamp?: string | null,
  updatedAt: string,
  user?: string | null,
};

export type ModelAccountFilterInput = {
  address?: ModelStringInput | null,
  and?: Array< ModelAccountFilterInput | null > | null,
  balance?: ModelFloatInput | null,
  city?: ModelStringInput | null,
  comunicationPreferences?: ModelAccountComunicationPreferencesInput | null,
  createdAt?: ModelStringInput | null,
  email?: ModelStringInput | null,
  firstName?: ModelStringInput | null,
  id?: ModelIDInput | null,
  isMobile?: ModelBooleanInput | null,
  lastName?: ModelStringInput | null,
  not?: ModelAccountFilterInput | null,
  number?: ModelStringInput | null,
  or?: Array< ModelAccountFilterInput | null > | null,
  original?: ModelStringInput | null,
  phoneNumber?: ModelStringInput | null,
  postcode?: ModelStringInput | null,
  state?: ModelStringInput | null,
  status?: ModelAccountStatusInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelStringInput = {
  attributeExists?: boolean | null,
  attributeType?: ModelAttributeTypes | null,
  beginsWith?: string | null,
  between?: Array< string | null > | null,
  contains?: string | null,
  eq?: string | null,
  ge?: string | null,
  gt?: string | null,
  le?: string | null,
  lt?: string | null,
  ne?: string | null,
  notContains?: string | null,
  size?: ModelSizeInput | null,
};

export enum ModelAttributeTypes {
  _null = "_null",
  binary = "binary",
  binarySet = "binarySet",
  bool = "bool",
  list = "list",
  map = "map",
  number = "number",
  numberSet = "numberSet",
  string = "string",
  stringSet = "stringSet",
}


export type ModelSizeInput = {
  between?: Array< number | null > | null,
  eq?: number | null,
  ge?: number | null,
  gt?: number | null,
  le?: number | null,
  lt?: number | null,
  ne?: number | null,
};

export type ModelFloatInput = {
  attributeExists?: boolean | null,
  attributeType?: ModelAttributeTypes | null,
  between?: Array< number | null > | null,
  eq?: number | null,
  ge?: number | null,
  gt?: number | null,
  le?: number | null,
  lt?: number | null,
  ne?: number | null,
};

export type ModelAccountComunicationPreferencesInput = {
  eq?: AccountComunicationPreferences | null,
  ne?: AccountComunicationPreferences | null,
};

export type ModelIDInput = {
  attributeExists?: boolean | null,
  attributeType?: ModelAttributeTypes | null,
  beginsWith?: string | null,
  between?: Array< string | null > | null,
  contains?: string | null,
  eq?: string | null,
  ge?: string | null,
  gt?: string | null,
  le?: string | null,
  lt?: string | null,
  ne?: string | null,
  notContains?: string | null,
  size?: ModelSizeInput | null,
};

export type ModelBooleanInput = {
  attributeExists?: boolean | null,
  attributeType?: ModelAttributeTypes | null,
  eq?: boolean | null,
  ne?: boolean | null,
};

export type ModelAccountStatusInput = {
  eq?: AccountStatus | null,
  ne?: AccountStatus | null,
};

export enum ModelSortDirection {
  ASC = "ASC",
  DESC = "DESC",
}


export type ModelAccountConnection = {
  __typename: "ModelAccountConnection",
  items:  Array<Account | null >,
  nextToken?: string | null,
};

export type ModelDashboardFilterInput = {
  and?: Array< ModelDashboardFilterInput | null > | null,
  config?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  email?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelDashboardFilterInput | null,
  or?: Array< ModelDashboardFilterInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelDashboardConnection = {
  __typename: "ModelDashboardConnection",
  items:  Array<Dashboard | null >,
  nextToken?: string | null,
};

export type ModelLoginFilterInput = {
  and?: Array< ModelLoginFilterInput | null > | null,
  config?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  email?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelLoginFilterInput | null,
  or?: Array< ModelLoginFilterInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelLoginConnection = {
  __typename: "ModelLoginConnection",
  items:  Array<Login | null >,
  nextToken?: string | null,
};

export type ModelSettingsFilterInput = {
  and?: Array< ModelSettingsFilterInput | null > | null,
  config?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  email?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelSettingsFilterInput | null,
  or?: Array< ModelSettingsFilterInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelSettingsConnection = {
  __typename: "ModelSettingsConnection",
  items:  Array<Settings | null >,
  nextToken?: string | null,
};

export type ModelSyncInfoFilterInput = {
  and?: Array< ModelSyncInfoFilterInput | null > | null,
  createdAt?: ModelStringInput | null,
  id?: ModelIDInput | null,
  info?: ModelStringInput | null,
  modelType?: ModelStringInput | null,
  not?: ModelSyncInfoFilterInput | null,
  or?: Array< ModelSyncInfoFilterInput | null > | null,
  timestamp?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  user?: ModelStringInput | null,
};

export type ModelSyncInfoConnection = {
  __typename: "ModelSyncInfoConnection",
  items:  Array<SyncInfo | null >,
  nextToken?: string | null,
};

export type ModelAccountConditionInput = {
  address?: ModelStringInput | null,
  and?: Array< ModelAccountConditionInput | null > | null,
  balance?: ModelFloatInput | null,
  city?: ModelStringInput | null,
  comunicationPreferences?: ModelAccountComunicationPreferencesInput | null,
  createdAt?: ModelStringInput | null,
  email?: ModelStringInput | null,
  firstName?: ModelStringInput | null,
  isMobile?: ModelBooleanInput | null,
  lastName?: ModelStringInput | null,
  not?: ModelAccountConditionInput | null,
  number?: ModelStringInput | null,
  or?: Array< ModelAccountConditionInput | null > | null,
  original?: ModelStringInput | null,
  phoneNumber?: ModelStringInput | null,
  postcode?: ModelStringInput | null,
  state?: ModelStringInput | null,
  status?: ModelAccountStatusInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateAccountInput = {
  address?: string | null,
  balance?: number | null,
  city?: string | null,
  comunicationPreferences?: AccountComunicationPreferences | null,
  email?: string | null,
  firstName: string,
  id?: string | null,
  isMobile?: boolean | null,
  lastName?: string | null,
  number: string,
  original?: string | null,
  phoneNumber?: string | null,
  postcode?: string | null,
  state?: string | null,
  status?: AccountStatus | null,
};

export type ModelDashboardConditionInput = {
  and?: Array< ModelDashboardConditionInput | null > | null,
  config?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  email?: ModelStringInput | null,
  not?: ModelDashboardConditionInput | null,
  or?: Array< ModelDashboardConditionInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateDashboardInput = {
  config?: string | null,
  email?: string | null,
  id?: string | null,
};

export type ModelLoginConditionInput = {
  and?: Array< ModelLoginConditionInput | null > | null,
  config?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  email?: ModelStringInput | null,
  not?: ModelLoginConditionInput | null,
  or?: Array< ModelLoginConditionInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateLoginInput = {
  config?: string | null,
  email?: string | null,
  id?: string | null,
};

export type ModelSettingsConditionInput = {
  and?: Array< ModelSettingsConditionInput | null > | null,
  config?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  email?: ModelStringInput | null,
  not?: ModelSettingsConditionInput | null,
  or?: Array< ModelSettingsConditionInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateSettingsInput = {
  config?: string | null,
  email?: string | null,
  id?: string | null,
};

export type ModelSyncInfoConditionInput = {
  and?: Array< ModelSyncInfoConditionInput | null > | null,
  createdAt?: ModelStringInput | null,
  info?: ModelStringInput | null,
  modelType?: ModelStringInput | null,
  not?: ModelSyncInfoConditionInput | null,
  or?: Array< ModelSyncInfoConditionInput | null > | null,
  timestamp?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  user?: ModelStringInput | null,
};

export type CreateSyncInfoInput = {
  id?: string | null,
  info?: string | null,
  modelType?: string | null,
  timestamp?: string | null,
  user?: string | null,
};

export type DeleteAccountInput = {
  id: string,
};

export type DeleteDashboardInput = {
  id: string,
};

export type DeleteLoginInput = {
  id: string,
};

export type DeleteSettingsInput = {
  id: string,
};

export type DeleteSyncInfoInput = {
  id: string,
};

export type ServerEvent = {
  __typename: "ServerEvent",
  eventId: string,
  eventType: ServerEventType,
  modelType: string,
  payload: string,
};

export enum ServerEventType {
  modelsync = "modelsync",
  notification = "notification",
  report = "report",
  undefined = "undefined",
}


export type UpdateAccountInput = {
  address?: string | null,
  balance?: number | null,
  city?: string | null,
  comunicationPreferences?: AccountComunicationPreferences | null,
  email?: string | null,
  firstName?: string | null,
  id: string,
  isMobile?: boolean | null,
  lastName?: string | null,
  number?: string | null,
  original?: string | null,
  phoneNumber?: string | null,
  postcode?: string | null,
  state?: string | null,
  status?: AccountStatus | null,
};

export type UpdateDashboardInput = {
  config?: string | null,
  email?: string | null,
  id: string,
};

export type UpdateLoginInput = {
  config?: string | null,
  email?: string | null,
  id: string,
};

export type UpdateSettingsInput = {
  config?: string | null,
  email?: string | null,
  id: string,
};

export type UpdateSyncInfoInput = {
  id: string,
  info?: string | null,
  modelType?: string | null,
  timestamp?: string | null,
  user?: string | null,
};

export type ModelSubscriptionAccountFilterInput = {
  address?: ModelSubscriptionStringInput | null,
  and?: Array< ModelSubscriptionAccountFilterInput | null > | null,
  balance?: ModelSubscriptionFloatInput | null,
  city?: ModelSubscriptionStringInput | null,
  comunicationPreferences?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  email?: ModelSubscriptionStringInput | null,
  firstName?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  isMobile?: ModelSubscriptionBooleanInput | null,
  lastName?: ModelSubscriptionStringInput | null,
  number?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionAccountFilterInput | null > | null,
  original?: ModelSubscriptionStringInput | null,
  phoneNumber?: ModelSubscriptionStringInput | null,
  postcode?: ModelSubscriptionStringInput | null,
  state?: ModelSubscriptionStringInput | null,
  status?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionStringInput = {
  beginsWith?: string | null,
  between?: Array< string | null > | null,
  contains?: string | null,
  eq?: string | null,
  ge?: string | null,
  gt?: string | null,
  in?: Array< string | null > | null,
  le?: string | null,
  lt?: string | null,
  ne?: string | null,
  notContains?: string | null,
  notIn?: Array< string | null > | null,
};

export type ModelSubscriptionFloatInput = {
  between?: Array< number | null > | null,
  eq?: number | null,
  ge?: number | null,
  gt?: number | null,
  in?: Array< number | null > | null,
  le?: number | null,
  lt?: number | null,
  ne?: number | null,
  notIn?: Array< number | null > | null,
};

export type ModelSubscriptionIDInput = {
  beginsWith?: string | null,
  between?: Array< string | null > | null,
  contains?: string | null,
  eq?: string | null,
  ge?: string | null,
  gt?: string | null,
  in?: Array< string | null > | null,
  le?: string | null,
  lt?: string | null,
  ne?: string | null,
  notContains?: string | null,
  notIn?: Array< string | null > | null,
};

export type ModelSubscriptionBooleanInput = {
  eq?: boolean | null,
  ne?: boolean | null,
};

export type ModelSubscriptionDashboardFilterInput = {
  and?: Array< ModelSubscriptionDashboardFilterInput | null > | null,
  config?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  email?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionDashboardFilterInput | null > | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionLoginFilterInput = {
  and?: Array< ModelSubscriptionLoginFilterInput | null > | null,
  config?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  email?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionLoginFilterInput | null > | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionSettingsFilterInput = {
  and?: Array< ModelSubscriptionSettingsFilterInput | null > | null,
  config?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  email?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionSettingsFilterInput | null > | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionSyncInfoFilterInput = {
  and?: Array< ModelSubscriptionSyncInfoFilterInput | null > | null,
  createdAt?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  info?: ModelSubscriptionStringInput | null,
  modelType?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionSyncInfoFilterInput | null > | null,
  timestamp?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
  user?: ModelSubscriptionStringInput | null,
};

export type GetAccountQueryVariables = {
  id: string,
};

export type GetAccountQuery = {
  getAccount?:  {
    __typename: "Account",
    address?: string | null,
    balance?: number | null,
    city?: string | null,
    comunicationPreferences?: AccountComunicationPreferences | null,
    createdAt: string,
    email?: string | null,
    firstName: string,
    id: string,
    isMobile?: boolean | null,
    lastName?: string | null,
    number: string,
    original?: string | null,
    phoneNumber?: string | null,
    postcode?: string | null,
    state?: string | null,
    status?: AccountStatus | null,
    updatedAt: string,
  } | null,
};

export type GetDashboardQueryVariables = {
  id: string,
};

export type GetDashboardQuery = {
  getDashboard?:  {
    __typename: "Dashboard",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type GetLoginQueryVariables = {
  id: string,
};

export type GetLoginQuery = {
  getLogin?:  {
    __typename: "Login",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type GetSettingsQueryVariables = {
  id: string,
};

export type GetSettingsQuery = {
  getSettings?:  {
    __typename: "Settings",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type GetSyncInfoQueryVariables = {
  id: string,
};

export type GetSyncInfoQuery = {
  getSyncInfo?:  {
    __typename: "SyncInfo",
    createdAt: string,
    id: string,
    info?: string | null,
    modelType?: string | null,
    timestamp?: string | null,
    updatedAt: string,
    user?: string | null,
  } | null,
};

export type ListAccountByNumberQueryVariables = {
  filter?: ModelAccountFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
  number: string,
  sortDirection?: ModelSortDirection | null,
};

export type ListAccountByNumberQuery = {
  listAccountByNumber?:  {
    __typename: "ModelAccountConnection",
    items:  Array< {
      __typename: "Account",
      address?: string | null,
      balance?: number | null,
      city?: string | null,
      comunicationPreferences?: AccountComunicationPreferences | null,
      createdAt: string,
      email?: string | null,
      firstName: string,
      id: string,
      isMobile?: boolean | null,
      lastName?: string | null,
      number: string,
      original?: string | null,
      phoneNumber?: string | null,
      postcode?: string | null,
      state?: string | null,
      status?: AccountStatus | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListAccountsQueryVariables = {
  filter?: ModelAccountFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListAccountsQuery = {
  listAccounts?:  {
    __typename: "ModelAccountConnection",
    items:  Array< {
      __typename: "Account",
      address?: string | null,
      balance?: number | null,
      city?: string | null,
      comunicationPreferences?: AccountComunicationPreferences | null,
      createdAt: string,
      email?: string | null,
      firstName: string,
      id: string,
      isMobile?: boolean | null,
      lastName?: string | null,
      number: string,
      original?: string | null,
      phoneNumber?: string | null,
      postcode?: string | null,
      state?: string | null,
      status?: AccountStatus | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListDashboardsQueryVariables = {
  filter?: ModelDashboardFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListDashboardsQuery = {
  listDashboards?:  {
    __typename: "ModelDashboardConnection",
    items:  Array< {
      __typename: "Dashboard",
      config?: string | null,
      createdAt: string,
      email?: string | null,
      id: string,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListLoginsQueryVariables = {
  filter?: ModelLoginFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListLoginsQuery = {
  listLogins?:  {
    __typename: "ModelLoginConnection",
    items:  Array< {
      __typename: "Login",
      config?: string | null,
      createdAt: string,
      email?: string | null,
      id: string,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListSettingsQueryVariables = {
  filter?: ModelSettingsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListSettingsQuery = {
  listSettings?:  {
    __typename: "ModelSettingsConnection",
    items:  Array< {
      __typename: "Settings",
      config?: string | null,
      createdAt: string,
      email?: string | null,
      id: string,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListSyncInfosQueryVariables = {
  filter?: ModelSyncInfoFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListSyncInfosQuery = {
  listSyncInfos?:  {
    __typename: "ModelSyncInfoConnection",
    items:  Array< {
      __typename: "SyncInfo",
      createdAt: string,
      id: string,
      info?: string | null,
      modelType?: string | null,
      timestamp?: string | null,
      updatedAt: string,
      user?: string | null,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type CreateAccountMutationVariables = {
  condition?: ModelAccountConditionInput | null,
  input: CreateAccountInput,
};

export type CreateAccountMutation = {
  createAccount?:  {
    __typename: "Account",
    address?: string | null,
    balance?: number | null,
    city?: string | null,
    comunicationPreferences?: AccountComunicationPreferences | null,
    createdAt: string,
    email?: string | null,
    firstName: string,
    id: string,
    isMobile?: boolean | null,
    lastName?: string | null,
    number: string,
    original?: string | null,
    phoneNumber?: string | null,
    postcode?: string | null,
    state?: string | null,
    status?: AccountStatus | null,
    updatedAt: string,
  } | null,
};

export type CreateDashboardMutationVariables = {
  condition?: ModelDashboardConditionInput | null,
  input: CreateDashboardInput,
};

export type CreateDashboardMutation = {
  createDashboard?:  {
    __typename: "Dashboard",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type CreateLoginMutationVariables = {
  condition?: ModelLoginConditionInput | null,
  input: CreateLoginInput,
};

export type CreateLoginMutation = {
  createLogin?:  {
    __typename: "Login",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type CreateSettingsMutationVariables = {
  condition?: ModelSettingsConditionInput | null,
  input: CreateSettingsInput,
};

export type CreateSettingsMutation = {
  createSettings?:  {
    __typename: "Settings",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type CreateSyncInfoMutationVariables = {
  condition?: ModelSyncInfoConditionInput | null,
  input: CreateSyncInfoInput,
};

export type CreateSyncInfoMutation = {
  createSyncInfo?:  {
    __typename: "SyncInfo",
    createdAt: string,
    id: string,
    info?: string | null,
    modelType?: string | null,
    timestamp?: string | null,
    updatedAt: string,
    user?: string | null,
  } | null,
};

export type DeleteAccountMutationVariables = {
  condition?: ModelAccountConditionInput | null,
  input: DeleteAccountInput,
};

export type DeleteAccountMutation = {
  deleteAccount?:  {
    __typename: "Account",
    address?: string | null,
    balance?: number | null,
    city?: string | null,
    comunicationPreferences?: AccountComunicationPreferences | null,
    createdAt: string,
    email?: string | null,
    firstName: string,
    id: string,
    isMobile?: boolean | null,
    lastName?: string | null,
    number: string,
    original?: string | null,
    phoneNumber?: string | null,
    postcode?: string | null,
    state?: string | null,
    status?: AccountStatus | null,
    updatedAt: string,
  } | null,
};

export type DeleteDashboardMutationVariables = {
  condition?: ModelDashboardConditionInput | null,
  input: DeleteDashboardInput,
};

export type DeleteDashboardMutation = {
  deleteDashboard?:  {
    __typename: "Dashboard",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type DeleteLoginMutationVariables = {
  condition?: ModelLoginConditionInput | null,
  input: DeleteLoginInput,
};

export type DeleteLoginMutation = {
  deleteLogin?:  {
    __typename: "Login",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type DeleteSettingsMutationVariables = {
  condition?: ModelSettingsConditionInput | null,
  input: DeleteSettingsInput,
};

export type DeleteSettingsMutation = {
  deleteSettings?:  {
    __typename: "Settings",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type DeleteSyncInfoMutationVariables = {
  condition?: ModelSyncInfoConditionInput | null,
  input: DeleteSyncInfoInput,
};

export type DeleteSyncInfoMutation = {
  deleteSyncInfo?:  {
    __typename: "SyncInfo",
    createdAt: string,
    id: string,
    info?: string | null,
    modelType?: string | null,
    timestamp?: string | null,
    updatedAt: string,
    user?: string | null,
  } | null,
};

export type PublishServerEventToEventBridgeMutationVariables = {
  eventId: string,
  eventType: string,
  modelType: string,
  payload: string,
};

export type PublishServerEventToEventBridgeMutation = {
  publishServerEventToEventBridge?:  {
    __typename: "ServerEvent",
    eventId: string,
    eventType: ServerEventType,
    modelType: string,
    payload: string,
  } | null,
};

export type UpdateAccountMutationVariables = {
  condition?: ModelAccountConditionInput | null,
  input: UpdateAccountInput,
};

export type UpdateAccountMutation = {
  updateAccount?:  {
    __typename: "Account",
    address?: string | null,
    balance?: number | null,
    city?: string | null,
    comunicationPreferences?: AccountComunicationPreferences | null,
    createdAt: string,
    email?: string | null,
    firstName: string,
    id: string,
    isMobile?: boolean | null,
    lastName?: string | null,
    number: string,
    original?: string | null,
    phoneNumber?: string | null,
    postcode?: string | null,
    state?: string | null,
    status?: AccountStatus | null,
    updatedAt: string,
  } | null,
};

export type UpdateDashboardMutationVariables = {
  condition?: ModelDashboardConditionInput | null,
  input: UpdateDashboardInput,
};

export type UpdateDashboardMutation = {
  updateDashboard?:  {
    __typename: "Dashboard",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type UpdateLoginMutationVariables = {
  condition?: ModelLoginConditionInput | null,
  input: UpdateLoginInput,
};

export type UpdateLoginMutation = {
  updateLogin?:  {
    __typename: "Login",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type UpdateSettingsMutationVariables = {
  condition?: ModelSettingsConditionInput | null,
  input: UpdateSettingsInput,
};

export type UpdateSettingsMutation = {
  updateSettings?:  {
    __typename: "Settings",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type UpdateSyncInfoMutationVariables = {
  condition?: ModelSyncInfoConditionInput | null,
  input: UpdateSyncInfoInput,
};

export type UpdateSyncInfoMutation = {
  updateSyncInfo?:  {
    __typename: "SyncInfo",
    createdAt: string,
    id: string,
    info?: string | null,
    modelType?: string | null,
    timestamp?: string | null,
    updatedAt: string,
    user?: string | null,
  } | null,
};

export type OnCreateAccountSubscriptionVariables = {
  filter?: ModelSubscriptionAccountFilterInput | null,
};

export type OnCreateAccountSubscription = {
  onCreateAccount?:  {
    __typename: "Account",
    address?: string | null,
    balance?: number | null,
    city?: string | null,
    comunicationPreferences?: AccountComunicationPreferences | null,
    createdAt: string,
    email?: string | null,
    firstName: string,
    id: string,
    isMobile?: boolean | null,
    lastName?: string | null,
    number: string,
    original?: string | null,
    phoneNumber?: string | null,
    postcode?: string | null,
    state?: string | null,
    status?: AccountStatus | null,
    updatedAt: string,
  } | null,
};

export type OnCreateDashboardSubscriptionVariables = {
  filter?: ModelSubscriptionDashboardFilterInput | null,
};

export type OnCreateDashboardSubscription = {
  onCreateDashboard?:  {
    __typename: "Dashboard",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type OnCreateLoginSubscriptionVariables = {
  filter?: ModelSubscriptionLoginFilterInput | null,
};

export type OnCreateLoginSubscription = {
  onCreateLogin?:  {
    __typename: "Login",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type OnCreateSettingsSubscriptionVariables = {
  filter?: ModelSubscriptionSettingsFilterInput | null,
};

export type OnCreateSettingsSubscription = {
  onCreateSettings?:  {
    __typename: "Settings",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type OnCreateSyncInfoSubscriptionVariables = {
  filter?: ModelSubscriptionSyncInfoFilterInput | null,
};

export type OnCreateSyncInfoSubscription = {
  onCreateSyncInfo?:  {
    __typename: "SyncInfo",
    createdAt: string,
    id: string,
    info?: string | null,
    modelType?: string | null,
    timestamp?: string | null,
    updatedAt: string,
    user?: string | null,
  } | null,
};

export type OnDeleteAccountSubscriptionVariables = {
  filter?: ModelSubscriptionAccountFilterInput | null,
};

export type OnDeleteAccountSubscription = {
  onDeleteAccount?:  {
    __typename: "Account",
    address?: string | null,
    balance?: number | null,
    city?: string | null,
    comunicationPreferences?: AccountComunicationPreferences | null,
    createdAt: string,
    email?: string | null,
    firstName: string,
    id: string,
    isMobile?: boolean | null,
    lastName?: string | null,
    number: string,
    original?: string | null,
    phoneNumber?: string | null,
    postcode?: string | null,
    state?: string | null,
    status?: AccountStatus | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteDashboardSubscriptionVariables = {
  filter?: ModelSubscriptionDashboardFilterInput | null,
};

export type OnDeleteDashboardSubscription = {
  onDeleteDashboard?:  {
    __typename: "Dashboard",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type OnDeleteLoginSubscriptionVariables = {
  filter?: ModelSubscriptionLoginFilterInput | null,
};

export type OnDeleteLoginSubscription = {
  onDeleteLogin?:  {
    __typename: "Login",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type OnDeleteSettingsSubscriptionVariables = {
  filter?: ModelSubscriptionSettingsFilterInput | null,
};

export type OnDeleteSettingsSubscription = {
  onDeleteSettings?:  {
    __typename: "Settings",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type OnDeleteSyncInfoSubscriptionVariables = {
  filter?: ModelSubscriptionSyncInfoFilterInput | null,
};

export type OnDeleteSyncInfoSubscription = {
  onDeleteSyncInfo?:  {
    __typename: "SyncInfo",
    createdAt: string,
    id: string,
    info?: string | null,
    modelType?: string | null,
    timestamp?: string | null,
    updatedAt: string,
    user?: string | null,
  } | null,
};

export type OnUpdateAccountSubscriptionVariables = {
  filter?: ModelSubscriptionAccountFilterInput | null,
};

export type OnUpdateAccountSubscription = {
  onUpdateAccount?:  {
    __typename: "Account",
    address?: string | null,
    balance?: number | null,
    city?: string | null,
    comunicationPreferences?: AccountComunicationPreferences | null,
    createdAt: string,
    email?: string | null,
    firstName: string,
    id: string,
    isMobile?: boolean | null,
    lastName?: string | null,
    number: string,
    original?: string | null,
    phoneNumber?: string | null,
    postcode?: string | null,
    state?: string | null,
    status?: AccountStatus | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateDashboardSubscriptionVariables = {
  filter?: ModelSubscriptionDashboardFilterInput | null,
};

export type OnUpdateDashboardSubscription = {
  onUpdateDashboard?:  {
    __typename: "Dashboard",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type OnUpdateLoginSubscriptionVariables = {
  filter?: ModelSubscriptionLoginFilterInput | null,
};

export type OnUpdateLoginSubscription = {
  onUpdateLogin?:  {
    __typename: "Login",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type OnUpdateSettingsSubscriptionVariables = {
  filter?: ModelSubscriptionSettingsFilterInput | null,
};

export type OnUpdateSettingsSubscription = {
  onUpdateSettings?:  {
    __typename: "Settings",
    config?: string | null,
    createdAt: string,
    email?: string | null,
    id: string,
    updatedAt: string,
  } | null,
};

export type OnUpdateSyncInfoSubscriptionVariables = {
  filter?: ModelSubscriptionSyncInfoFilterInput | null,
};

export type OnUpdateSyncInfoSubscription = {
  onUpdateSyncInfo?:  {
    __typename: "SyncInfo",
    createdAt: string,
    id: string,
    info?: string | null,
    modelType?: string | null,
    timestamp?: string | null,
    updatedAt: string,
    user?: string | null,
  } | null,
};
