// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amplify_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmplifyOutput _$AmplifyOutputFromJson(Map<String, dynamic> json) =>
    AmplifyOutput(
      analytics: json['analytics'] == null
          ? null
          : Analytics.fromJson(json['analytics'] as Map<String, dynamic>),
      auth: json['auth'] == null
          ? null
          : Auth.fromJson(json['auth'] as Map<String, dynamic>),
      custom: json['custom'] as Map<String, dynamic>?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      geo: json['geo'] == null
          ? null
          : Geo.fromJson(json['geo'] as Map<String, dynamic>),
      notifications: json['notifications'] == null
          ? null
          : Notifications.fromJson(
              json['notifications'] as Map<String, dynamic>),
      storage: json['storage'] == null
          ? null
          : Storage.fromJson(json['storage'] as Map<String, dynamic>),
      version: $enumDecode(_$VersionEnumMap, json['version']),
    );

Map<String, dynamic> _$AmplifyOutputToJson(AmplifyOutput instance) =>
    <String, dynamic>{
      'analytics': instance.analytics,
      'auth': instance.auth,
      'custom': instance.custom,
      'data': instance.data,
      'geo': instance.geo,
      'notifications': instance.notifications,
      'storage': instance.storage,
      'version': _$VersionEnumMap[instance.version]!,
    };

const _$VersionEnumMap = {
  Version.THE_1: '1',
};

Analytics _$AnalyticsFromJson(Map<String, dynamic> json) => Analytics(
      amazonPinpoint: json['amazon_pinpoint'] == null
          ? null
          : AmazonPinpoint.fromJson(
              json['amazon_pinpoint'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnalyticsToJson(Analytics instance) => <String, dynamic>{
      'amazon_pinpoint': instance.amazonPinpoint,
    };

AmazonPinpoint _$AmazonPinpointFromJson(Map<String, dynamic> json) =>
    AmazonPinpoint(
      appId: json['app_id'] as String,
      awsRegion: json['aws_region'] as String,
    );

Map<String, dynamic> _$AmazonPinpointToJson(AmazonPinpoint instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'aws_region': instance.awsRegion,
    };

Auth _$AuthFromJson(Map<String, dynamic> json) => Auth(
      awsRegion: json['aws_region'] as String,
      identityPoolId: json['identity_pool_id'] as String?,
      mfaConfiguration: $enumDecodeNullable(
          _$MfaConfigurationEnumMap, json['mfa_configuration']),
      mfaMethods: (json['mfa_methods'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MfaMethodEnumMap, e))
          .toList(),
      oauth: json['oauth'] == null
          ? null
          : Oauth.fromJson(json['oauth'] as Map<String, dynamic>),
      passwordPolicy: json['password_policy'] == null
          ? null
          : PasswordPolicy.fromJson(
              json['password_policy'] as Map<String, dynamic>),
      standardRequiredAttributes: (json['standard_required_attributes']
              as List<dynamic>?)
          ?.map(
              (e) => $enumDecode(_$StandardRequiredAttributeElementEnumMap, e))
          .toList(),
      unauthenticatedIdentitiesEnabled:
          json['unauthenticated_identities_enabled'] as bool?,
      userPoolClientId: json['user_pool_client_id'] as String,
      userPoolId: json['user_pool_id'] as String,
      userVerificationTypes: (json['user_verification_types'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$UserVerificationTypeEnumMap, e))
          .toList(),
      usernameAttributes: (json['username_attributes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$UsernameAttributeEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'aws_region': instance.awsRegion,
      'identity_pool_id': instance.identityPoolId,
      'mfa_configuration': _$MfaConfigurationEnumMap[instance.mfaConfiguration],
      'mfa_methods':
          instance.mfaMethods?.map((e) => _$MfaMethodEnumMap[e]!).toList(),
      'oauth': instance.oauth,
      'password_policy': instance.passwordPolicy,
      'standard_required_attributes': instance.standardRequiredAttributes
          ?.map((e) => _$StandardRequiredAttributeElementEnumMap[e]!)
          .toList(),
      'unauthenticated_identities_enabled':
          instance.unauthenticatedIdentitiesEnabled,
      'user_pool_client_id': instance.userPoolClientId,
      'user_pool_id': instance.userPoolId,
      'user_verification_types': instance.userVerificationTypes
          ?.map((e) => _$UserVerificationTypeEnumMap[e]!)
          .toList(),
      'username_attributes': instance.usernameAttributes
          ?.map((e) => _$UsernameAttributeEnumMap[e]!)
          .toList(),
    };

const _$MfaConfigurationEnumMap = {
  MfaConfiguration.NONE: 'NONE',
  MfaConfiguration.OPTIONAL: 'OPTIONAL',
  MfaConfiguration.REQUIRED: 'REQUIRED',
};

const _$MfaMethodEnumMap = {
  MfaMethod.SMS: 'SMS',
  MfaMethod.TOTP: 'TOTP',
};

const _$StandardRequiredAttributeElementEnumMap = {
  StandardRequiredAttributeElement.ADDRESS: 'address',
  StandardRequiredAttributeElement.BIRTHDATE: 'birthdate',
  StandardRequiredAttributeElement.EMAIL: 'email',
  StandardRequiredAttributeElement.FAMILY_NAME: 'family_name',
  StandardRequiredAttributeElement.GENDER: 'gender',
  StandardRequiredAttributeElement.GIVEN_NAME: 'given_name',
  StandardRequiredAttributeElement.LOCALE: 'locale',
  StandardRequiredAttributeElement.MIDDLE_NAME: 'middle_name',
  StandardRequiredAttributeElement.NAME: 'name',
  StandardRequiredAttributeElement.NICKNAME: 'nickname',
  StandardRequiredAttributeElement.PHONE_NUMBER: 'phone_number',
  StandardRequiredAttributeElement.PICTURE: 'picture',
  StandardRequiredAttributeElement.PREFERRED_USERNAME: 'preferred_username',
  StandardRequiredAttributeElement.PROFILE: 'profile',
  StandardRequiredAttributeElement.SUB: 'sub',
  StandardRequiredAttributeElement.UPDATED_AT: 'updated_at',
  StandardRequiredAttributeElement.WEBSITE: 'website',
  StandardRequiredAttributeElement.ZONEINFO: 'zoneinfo',
};

const _$UserVerificationTypeEnumMap = {
  UserVerificationType.EMAIL: 'email',
  UserVerificationType.PHONE_NUMBER: 'phone_number',
};

const _$UsernameAttributeEnumMap = {
  UsernameAttribute.EMAIL: 'email',
  UsernameAttribute.PHONE_NUMBER: 'phone_number',
  UsernameAttribute.USERNAME: 'username',
};

Oauth _$OauthFromJson(Map<String, dynamic> json) => Oauth(
      domain: json['domain'] as String,
      identityProviders: (json['identity_providers'] as List<dynamic>)
          .map((e) => $enumDecode(_$IdentityProviderEnumMap, e))
          .toList(),
      redirectSignInUri: (json['redirect_sign_in_uri'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      redirectSignOutUri: (json['redirect_sign_out_uri'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      responseType: $enumDecode(_$ResponseTypeEnumMap, json['response_type']),
      scopes:
          (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$OauthToJson(Oauth instance) => <String, dynamic>{
      'domain': instance.domain,
      'identity_providers': instance.identityProviders
          .map((e) => _$IdentityProviderEnumMap[e]!)
          .toList(),
      'redirect_sign_in_uri': instance.redirectSignInUri,
      'redirect_sign_out_uri': instance.redirectSignOutUri,
      'response_type': _$ResponseTypeEnumMap[instance.responseType]!,
      'scopes': instance.scopes,
    };

const _$IdentityProviderEnumMap = {
  IdentityProvider.FACEBOOK: 'FACEBOOK',
  IdentityProvider.GOOGLE: 'GOOGLE',
  IdentityProvider.LOGIN_WITH_AMAZON: 'LOGIN_WITH_AMAZON',
  IdentityProvider.SIGN_IN_WITH_APPLE: 'SIGN_IN_WITH_APPLE',
};

const _$ResponseTypeEnumMap = {
  ResponseType.CODE: 'code',
  ResponseType.TOKEN: 'token',
};

PasswordPolicy _$PasswordPolicyFromJson(Map<String, dynamic> json) =>
    PasswordPolicy(
      minLength: json['min_length'] as int?,
      requireLowercase: json['require_lowercase'] as bool?,
      requireNumbers: json['require_numbers'] as bool?,
      requireSymbols: json['require_symbols'] as bool?,
      requireUppercase: json['require_uppercase'] as bool?,
    );

Map<String, dynamic> _$PasswordPolicyToJson(PasswordPolicy instance) =>
    <String, dynamic>{
      'min_length': instance.minLength,
      'require_lowercase': instance.requireLowercase,
      'require_numbers': instance.requireNumbers,
      'require_symbols': instance.requireSymbols,
      'require_uppercase': instance.requireUppercase,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      apiKey: json['api_key'] as String?,
      authorizationTypes: (json['authorization_types'] as List<dynamic>)
          .map((e) => $enumDecode(_$AmplifyOutpuEnumMap, e))
          .toList(),
      awsRegion: json['aws_region'] as String,
      defaultAuthorizationType: $enumDecode(
          _$AmplifyOutpuEnumMap, json['default_authorization_type']),
      modelIntrospection: json['model_introspection'] as Map<String, dynamic>?,
      url: json['url'] as String,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'api_key': instance.apiKey,
      'authorization_types': instance.authorizationTypes
          .map((e) => _$AmplifyOutpuEnumMap[e]!)
          .toList(),
      'aws_region': instance.awsRegion,
      'default_authorization_type':
          _$AmplifyOutpuEnumMap[instance.defaultAuthorizationType]!,
      'model_introspection': instance.modelIntrospection,
      'url': instance.url,
    };

const _$AmplifyOutpuEnumMap = {
  AmplifyOutpu.AMAZON_COGNITO_USER_POOLS: 'AMAZON_COGNITO_USER_POOLS',
  AmplifyOutpu.API_KEY: 'API_KEY',
  AmplifyOutpu.AWS_IAM: 'AWS_IAM',
  AmplifyOutpu.AWS_LAMBDA: 'AWS_LAMBDA',
  AmplifyOutpu.OPENID_CONNECT: 'OPENID_CONNECT',
};

Geo _$GeoFromJson(Map<String, dynamic> json) => Geo(
      awsRegion: json['aws_region'] as String,
      geofenceCollections: json['geofence_collections'] == null
          ? null
          : GeofenceCollections.fromJson(
              json['geofence_collections'] as Map<String, dynamic>),
      maps: json['maps'] == null
          ? null
          : Maps.fromJson(json['maps'] as Map<String, dynamic>),
      searchIndices: json['search_indices'] == null
          ? null
          : SearchIndices.fromJson(
              json['search_indices'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeoToJson(Geo instance) => <String, dynamic>{
      'aws_region': instance.awsRegion,
      'geofence_collections': instance.geofenceCollections,
      'maps': instance.maps,
      'search_indices': instance.searchIndices,
    };

GeofenceCollections _$GeofenceCollectionsFromJson(Map<String, dynamic> json) =>
    GeofenceCollections(
      geofenceCollectionsDefault: json['default'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GeofenceCollectionsToJson(
        GeofenceCollections instance) =>
    <String, dynamic>{
      'default': instance.geofenceCollectionsDefault,
      'items': instance.items,
    };

Maps _$MapsFromJson(Map<String, dynamic> json) => Maps(
      mapsDefault: json['default'] as String,
      items: Items.fromJson(json['items'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MapsToJson(Maps instance) => <String, dynamic>{
      'default': instance.mapsDefault,
      'items': instance.items,
    };

Items _$ItemsFromJson(Map<String, dynamic> json) => Items();

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{};

SearchIndices _$SearchIndicesFromJson(Map<String, dynamic> json) =>
    SearchIndices(
      searchIndicesDefault: json['default'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SearchIndicesToJson(SearchIndices instance) =>
    <String, dynamic>{
      'default': instance.searchIndicesDefault,
      'items': instance.items,
    };

Notifications _$NotificationsFromJson(Map<String, dynamic> json) =>
    Notifications(
      amazonPinpointAppId: json['amazon_pinpoint_app_id'] as String,
      awsRegion: json['aws_region'] as String,
      channels: (json['channels'] as List<dynamic>)
          .map((e) => $enumDecode(_$ChannelElementEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$NotificationsToJson(Notifications instance) =>
    <String, dynamic>{
      'amazon_pinpoint_app_id': instance.amazonPinpointAppId,
      'aws_region': instance.awsRegion,
      'channels':
          instance.channels.map((e) => _$ChannelElementEnumMap[e]!).toList(),
    };

const _$ChannelElementEnumMap = {
  ChannelElement.APNS: 'APNS',
  ChannelElement.EMAIL: 'EMAIL',
  ChannelElement.FCM: 'FCM',
  ChannelElement.IN_APP_MESSAGING: 'IN_APP_MESSAGING',
  ChannelElement.SMS: 'SMS',
};

Storage _$StorageFromJson(Map<String, dynamic> json) => Storage(
      awsRegion: json['aws_region'] as String,
      bucketName: json['bucket_name'] as String,
    );

Map<String, dynamic> _$StorageToJson(Storage instance) => <String, dynamic>{
      'aws_region': instance.awsRegion,
      'bucket_name': instance.bucketName,
    };
