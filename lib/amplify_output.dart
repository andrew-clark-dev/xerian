// ignore_for_file: unnecessary_string_interpolations, constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'amplify_output.g.dart';

///Config format for Amplify Gen 2 client libraries to communicate with backend services.
@JsonSerializable()
class AmplifyOutput {
  ///Outputs manually specified by developers for use with frontend library
  @JsonKey(name: "analytics")
  final Analytics? analytics;

  ///Outputs generated from defineAuth
  @JsonKey(name: "auth")
  final Auth? auth;

  ///Outputs generated from backend.addOutput({ custom: <config> })
  @JsonKey(name: "custom")
  final Map<String, dynamic>? custom;

  ///Outputs generated from defineData
  @JsonKey(name: "data")
  final Data? data;

  ///Outputs manually specified by developers for use with frontend library
  @JsonKey(name: "geo")
  final Geo? geo;

  ///Outputs manually specified by developers for use with frontend library
  @JsonKey(name: "notifications")
  final Notifications? notifications;

  ///Outputs generated from defineStorage
  @JsonKey(name: "storage")
  final Storage? storage;

  ///Version of this schema
  @JsonKey(name: "version")
  final Version version;

  AmplifyOutput({
    this.analytics,
    this.auth,
    this.custom,
    this.data,
    this.geo,
    this.notifications,
    this.storage,
    required this.version,
  });

  factory AmplifyOutput.fromJson(Map<String, dynamic> json) =>
      _$AmplifyOutputFromJson(json);

  Map<String, dynamic> toJson() => _$AmplifyOutputToJson(this);
}

///Outputs manually specified by developers for use with frontend library
@JsonSerializable()
class Analytics {
  @JsonKey(name: "amazon_pinpoint")
  final AmazonPinpoint? amazonPinpoint;

  Analytics({
    this.amazonPinpoint,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsToJson(this);
}

@JsonSerializable()
class AmazonPinpoint {
  @JsonKey(name: "app_id")
  final String appId;

  ///AWS Region of Amazon Pinpoint resources
  @JsonKey(name: "aws_region")
  final String awsRegion;

  AmazonPinpoint({
    required this.appId,
    required this.awsRegion,
  });

  factory AmazonPinpoint.fromJson(Map<String, dynamic> json) =>
      _$AmazonPinpointFromJson(json);

  Map<String, dynamic> toJson() => _$AmazonPinpointToJson(this);
}

///Outputs generated from defineAuth
@JsonSerializable()
class Auth {
  ///AWS Region of Amazon Cognito resources
  @JsonKey(name: "aws_region")
  final String awsRegion;

  ///Cognito Identity Pool ID
  @JsonKey(name: "identity_pool_id")
  final String? identityPoolId;
  @JsonKey(name: "mfa_configuration")
  final MfaConfiguration? mfaConfiguration;
  @JsonKey(name: "mfa_methods")
  final List<MfaMethod>? mfaMethods;
  @JsonKey(name: "oauth")
  final Oauth? oauth;

  ///Cognito User Pool password policy
  @JsonKey(name: "password_policy")
  final PasswordPolicy? passwordPolicy;

  ///Cognito User Pool standard attributes required for signup
  @JsonKey(name: "standard_required_attributes")
  final List<StandardRequiredAttributeElement>? standardRequiredAttributes;
  @JsonKey(name: "unauthenticated_identities_enabled")
  final bool? unauthenticatedIdentitiesEnabled;

  ///Cognito User Pool Client ID
  @JsonKey(name: "user_pool_client_id")
  final String userPoolClientId;

  ///Cognito User Pool ID
  @JsonKey(name: "user_pool_id")
  final String userPoolId;
  @JsonKey(name: "user_verification_types")
  final List<UserVerificationType>? userVerificationTypes;

  ///Cognito User Pool username attributes
  @JsonKey(name: "username_attributes")
  final List<UsernameAttribute>? usernameAttributes;

  Auth({
    required this.awsRegion,
    this.identityPoolId,
    this.mfaConfiguration,
    this.mfaMethods,
    this.oauth,
    this.passwordPolicy,
    this.standardRequiredAttributes,
    this.unauthenticatedIdentitiesEnabled,
    required this.userPoolClientId,
    required this.userPoolId,
    this.userVerificationTypes,
    this.usernameAttributes,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  Map<String, dynamic> toJson() => _$AuthToJson(this);
}

enum MfaConfiguration {
  @JsonValue("NONE")
  NONE,
  @JsonValue("OPTIONAL")
  OPTIONAL,
  @JsonValue("REQUIRED")
  REQUIRED
}

enum MfaMethod {
  @JsonValue("SMS")
  SMS,
  @JsonValue("TOTP")
  TOTP
}

@JsonSerializable()
class Oauth {
  ///Domain used for identity providers
  @JsonKey(name: "domain")
  final String domain;

  ///Identity providers set on Cognito User Pool
  @JsonKey(name: "identity_providers")
  final List<IdentityProvider> identityProviders;

  ///URIs used to redirect after signing in using an identity provider
  @JsonKey(name: "redirect_sign_in_uri")
  final List<String> redirectSignInUri;

  ///URIs used to redirect after signing out
  @JsonKey(name: "redirect_sign_out_uri")
  final List<String> redirectSignOutUri;
  @JsonKey(name: "response_type")
  final ResponseType responseType;
  @JsonKey(name: "scopes")
  final List<String> scopes;

  Oauth({
    required this.domain,
    required this.identityProviders,
    required this.redirectSignInUri,
    required this.redirectSignOutUri,
    required this.responseType,
    required this.scopes,
  });

  factory Oauth.fromJson(Map<String, dynamic> json) => _$OauthFromJson(json);

  Map<String, dynamic> toJson() => _$OauthToJson(this);
}

enum IdentityProvider {
  @JsonValue("FACEBOOK")
  FACEBOOK,
  @JsonValue("GOOGLE")
  GOOGLE,
  @JsonValue("LOGIN_WITH_AMAZON")
  LOGIN_WITH_AMAZON,
  @JsonValue("SIGN_IN_WITH_APPLE")
  SIGN_IN_WITH_APPLE
}

enum ResponseType {
  @JsonValue("code")
  CODE,
  @JsonValue("token")
  TOKEN
}

///Cognito User Pool password policy
@JsonSerializable()
class PasswordPolicy {
  @JsonKey(name: "min_length")
  final int? minLength;
  @JsonKey(name: "require_lowercase")
  final bool? requireLowercase;
  @JsonKey(name: "require_numbers")
  final bool? requireNumbers;
  @JsonKey(name: "require_symbols")
  final bool? requireSymbols;
  @JsonKey(name: "require_uppercase")
  final bool? requireUppercase;

  PasswordPolicy({
    this.minLength,
    this.requireLowercase,
    this.requireNumbers,
    this.requireSymbols,
    this.requireUppercase,
  });

  factory PasswordPolicy.fromJson(Map<String, dynamic> json) =>
      _$PasswordPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordPolicyToJson(this);
}

///Amazon Cognito standard attributes for users --
///https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
enum StandardRequiredAttributeElement {
  @JsonValue("address")
  ADDRESS,
  @JsonValue("birthdate")
  BIRTHDATE,
  @JsonValue("email")
  EMAIL,
  @JsonValue("family_name")
  FAMILY_NAME,
  @JsonValue("gender")
  GENDER,
  @JsonValue("given_name")
  GIVEN_NAME,
  @JsonValue("locale")
  LOCALE,
  @JsonValue("middle_name")
  MIDDLE_NAME,
  @JsonValue("name")
  NAME,
  @JsonValue("nickname")
  NICKNAME,
  @JsonValue("phone_number")
  PHONE_NUMBER,
  @JsonValue("picture")
  PICTURE,
  @JsonValue("preferred_username")
  PREFERRED_USERNAME,
  @JsonValue("profile")
  PROFILE,
  @JsonValue("sub")
  SUB,
  @JsonValue("updated_at")
  UPDATED_AT,
  @JsonValue("website")
  WEBSITE,
  @JsonValue("zoneinfo")
  ZONEINFO
}

enum UserVerificationType {
  @JsonValue("email")
  EMAIL,
  @JsonValue("phone_number")
  PHONE_NUMBER
}

enum UsernameAttribute {
  @JsonValue("email")
  EMAIL,
  @JsonValue("phone_number")
  PHONE_NUMBER,
  @JsonValue("username")
  USERNAME
}

///Outputs generated from defineData
@JsonSerializable()
class Data {
  @JsonKey(name: "api_key")
  final String? apiKey;
  @JsonKey(name: "authorization_types")
  final List<AmplifyOutpu> authorizationTypes;
  @JsonKey(name: "aws_region")
  final String awsRegion;
  @JsonKey(name: "default_authorization_type")
  final AmplifyOutpu defaultAuthorizationType;

  ///generated model introspection schema for use with generateClient
  @JsonKey(name: "model_introspection")
  final Map<String, dynamic>? modelIntrospection;

  ///AppSync endpoint URL
  @JsonKey(name: "url")
  final String url;

  Data({
    this.apiKey,
    required this.authorizationTypes,
    required this.awsRegion,
    required this.defaultAuthorizationType,
    this.modelIntrospection,
    required this.url,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

///List of supported auth types for AWS AppSync
enum AmplifyOutpu {
  @JsonValue("AMAZON_COGNITO_USER_POOLS")
  AMAZON_COGNITO_USER_POOLS,
  @JsonValue("API_KEY")
  API_KEY,
  @JsonValue("AWS_IAM")
  AWS_IAM,
  @JsonValue("AWS_LAMBDA")
  AWS_LAMBDA,
  @JsonValue("OPENID_CONNECT")
  OPENID_CONNECT
}

///Outputs manually specified by developers for use with frontend library
@JsonSerializable()
class Geo {
  ///AWS Region of Amazon Location Service resources
  @JsonKey(name: "aws_region")
  final String awsRegion;

  ///Geofencing (visualize virtual perimeters)
  @JsonKey(name: "geofence_collections")
  final GeofenceCollections? geofenceCollections;

  ///Maps from Amazon Location Service
  @JsonKey(name: "maps")
  final Maps? maps;

  ///Location search (search by places, addresses, coordinates)
  @JsonKey(name: "search_indices")
  final SearchIndices? searchIndices;

  Geo({
    required this.awsRegion,
    this.geofenceCollections,
    this.maps,
    this.searchIndices,
  });

  factory Geo.fromJson(Map<String, dynamic> json) => _$GeoFromJson(json);

  Map<String, dynamic> toJson() => _$GeoToJson(this);
}

///Geofencing (visualize virtual perimeters)
@JsonSerializable()
class GeofenceCollections {
  @JsonKey(name: "default")
  final String geofenceCollectionsDefault;
  @JsonKey(name: "items")
  final List<String> items;

  GeofenceCollections({
    required this.geofenceCollectionsDefault,
    required this.items,
  });

  factory GeofenceCollections.fromJson(Map<String, dynamic> json) =>
      _$GeofenceCollectionsFromJson(json);

  Map<String, dynamic> toJson() => _$GeofenceCollectionsToJson(this);
}

///Maps from Amazon Location Service
@JsonSerializable()
class Maps {
  @JsonKey(name: "default")
  final String mapsDefault;
  @JsonKey(name: "items")
  final Items items;

  Maps({
    required this.mapsDefault,
    required this.items,
  });

  factory Maps.fromJson(Map<String, dynamic> json) => _$MapsFromJson(json);

  Map<String, dynamic> toJson() => _$MapsToJson(this);
}

@JsonSerializable()
class Items {
  Items();

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

///Location search (search by places, addresses, coordinates)
@JsonSerializable()
class SearchIndices {
  @JsonKey(name: "default")
  final String searchIndicesDefault;
  @JsonKey(name: "items")
  final List<String> items;

  SearchIndices({
    required this.searchIndicesDefault,
    required this.items,
  });

  factory SearchIndices.fromJson(Map<String, dynamic> json) =>
      _$SearchIndicesFromJson(json);

  Map<String, dynamic> toJson() => _$SearchIndicesToJson(this);
}

///Outputs manually specified by developers for use with frontend library
@JsonSerializable()
class Notifications {
  @JsonKey(name: "amazon_pinpoint_app_id")
  final String amazonPinpointAppId;
  @JsonKey(name: "aws_region")
  final String awsRegion;
  @JsonKey(name: "channels")
  final List<ChannelElement> channels;

  Notifications({
    required this.amazonPinpointAppId,
    required this.awsRegion,
    required this.channels,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) =>
      _$NotificationsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsToJson(this);
}

///supported channels for Amazon Pinpoint
enum ChannelElement {
  @JsonValue("APNS")
  APNS,
  @JsonValue("EMAIL")
  EMAIL,
  @JsonValue("FCM")
  FCM,
  @JsonValue("IN_APP_MESSAGING")
  IN_APP_MESSAGING,
  @JsonValue("SMS")
  SMS
}

///Outputs generated from defineStorage
@JsonSerializable()
class Storage {
  @JsonKey(name: "aws_region")
  final String awsRegion;
  @JsonKey(name: "bucket_name")
  final String bucketName;

  Storage({
    required this.awsRegion,
    required this.bucketName,
  });

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);

  Map<String, dynamic> toJson() => _$StorageToJson(this);
}

enum Version {
  @JsonValue("1")
  THE_1
}
