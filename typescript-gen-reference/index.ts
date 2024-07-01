import { ModelInit, MutableModel, PersistentModelConstructor } from "@aws-amplify/datastore";
import { initSchema } from "@aws-amplify/datastore";

import { schema } from "./schema";

export enum ServerEventType {
  MODELSYNC = "modelsync",
  REPORT = "report",
  NOTIFICATION = "notification",
  UNDEFINED = "undefined"
}

export enum AccountComunicationPreferences {
  SMS = "sms",
  EMAIL = "email",
  NONE = "none",
  ALL = "all"
}

export enum AccountStatus {
  ACTIVE = "active",
  INACTIVE = "inactive",
  SUSPENDED = "suspended"
}

type EagerLoginModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Login, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly email?: string | null;
  readonly config?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyLoginModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Login, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly email?: string | null;
  readonly config?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type LoginModel = LazyLoading extends LazyLoadingDisabled ? EagerLoginModel : LazyLoginModel

export declare const LoginModel: (new (init: ModelInit<LoginModel>) => LoginModel) & {
  copyOf(source: LoginModel, mutator: (draft: MutableModel<LoginModel>) => MutableModel<LoginModel> | void): LoginModel;
}

type EagerDashboardModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Dashboard, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly email?: string | null;
  readonly config?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyDashboardModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Dashboard, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly email?: string | null;
  readonly config?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type DashboardModel = LazyLoading extends LazyLoadingDisabled ? EagerDashboardModel : LazyDashboardModel

export declare const DashboardModel: (new (init: ModelInit<DashboardModel>) => DashboardModel) & {
  copyOf(source: DashboardModel, mutator: (draft: MutableModel<DashboardModel>) => MutableModel<DashboardModel> | void): DashboardModel;
}

type EagerSettingsModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Settings, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly email?: string | null;
  readonly config?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazySettingsModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Settings, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly email?: string | null;
  readonly config?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type SettingsModel = LazyLoading extends LazyLoadingDisabled ? EagerSettingsModel : LazySettingsModel

export declare const SettingsModel: (new (init: ModelInit<SettingsModel>) => SettingsModel) & {
  copyOf(source: SettingsModel, mutator: (draft: MutableModel<SettingsModel>) => MutableModel<SettingsModel> | void): SettingsModel;
}

type EagerSyncInfoModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<SyncInfo, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly modelType?: string | null;
  readonly user?: string | null;
  readonly timestamp?: string | null;
  readonly info?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazySyncInfoModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<SyncInfo, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly modelType?: string | null;
  readonly user?: string | null;
  readonly timestamp?: string | null;
  readonly info?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type SyncInfoModel = LazyLoading extends LazyLoadingDisabled ? EagerSyncInfoModel : LazySyncInfoModel

export declare const SyncInfoModel: (new (init: ModelInit<SyncInfoModel>) => SyncInfoModel) & {
  copyOf(source: SyncInfoModel, mutator: (draft: MutableModel<SyncInfoModel>) => MutableModel<SyncInfoModel> | void): SyncInfoModel;
}

type EagerAccountModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Account, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly number: string;
  readonly firstName: string;
  readonly lastName?: string | null;
  readonly email?: string | null;
  readonly phoneNumber?: string | null;
  readonly isMobile?: boolean | null;
  readonly address?: string | null;
  readonly city?: string | null;
  readonly state?: string | null;
  readonly postcode?: string | null;
  readonly balance?: number | null;
  readonly comunicationPreferences?: AccountComunicationPreferences | keyof typeof AccountComunicationPreferences | null;
  readonly status?: AccountStatus | keyof typeof AccountStatus | null;
  readonly original?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyAccountModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Account, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly number: string;
  readonly firstName: string;
  readonly lastName?: string | null;
  readonly email?: string | null;
  readonly phoneNumber?: string | null;
  readonly isMobile?: boolean | null;
  readonly address?: string | null;
  readonly city?: string | null;
  readonly state?: string | null;
  readonly postcode?: string | null;
  readonly balance?: number | null;
  readonly comunicationPreferences?: AccountComunicationPreferences | keyof typeof AccountComunicationPreferences | null;
  readonly status?: AccountStatus | keyof typeof AccountStatus | null;
  readonly original?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type AccountModel = LazyLoading extends LazyLoadingDisabled ? EagerAccountModel : LazyAccountModel

export declare const AccountModel: (new (init: ModelInit<AccountModel>) => AccountModel) & {
  copyOf(source: AccountModel, mutator: (draft: MutableModel<AccountModel>) => MutableModel<AccountModel> | void): AccountModel;
}

type EagerServerEventModel = {
  readonly eventId: string;
  readonly eventType: ServerEventType | keyof typeof ServerEventType;
  readonly modelType: string;
  readonly payload: string;
}

type LazyServerEventModel = {
  readonly eventId: string;
  readonly eventType: ServerEventType | keyof typeof ServerEventType;
  readonly modelType: string;
  readonly payload: string;
}

export declare type ServerEventModel = LazyLoading extends LazyLoadingDisabled ? EagerServerEventModel : LazyServerEventModel

export declare const ServerEventModel: (new (init: ModelInit<ServerEventModel>) => ServerEventModel)

const { Login, Dashboard, Settings, SyncInfo, Account, ServerEvent } = initSchema(schema) as {
  Login: PersistentModelConstructor<LoginModel>;
  Dashboard: PersistentModelConstructor<DashboardModel>;
  Settings: PersistentModelConstructor<SettingsModel>;
  SyncInfo: PersistentModelConstructor<SyncInfoModel>;
  Account: PersistentModelConstructor<AccountModel>;
  ServerEvent: PersistentModelConstructor<ServerEventModel>;
};

export {
  Login,
  Dashboard,
  Settings,
  SyncInfo,
  Account
};