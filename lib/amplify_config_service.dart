import 'dart:convert';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/services.dart';

import 'amplify_output.dart';

class AmplifyConfigService {
  static Future<String> getConfigFromJson() async {
    final String jsonString =
        await rootBundle.loadString('lib/amplifyconfiguration.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    return '''{
  "UserAgent": "@aws-amplify/client-config/1.0.2",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "@aws-amplify/client-config/1.0.2",
        "Version": "1.0",
        "CognitoUserPool": {
          "Default": {
            "PoolId": "${data['aws_user_pools_id']}",
            "AppClientId": "${data['aws_user_pools_web_client_id']}",
            "Region": "${data['aws_cognito_region']}"
          }
        },
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "${data['aws_cognito_identity_pool_id']}",
              "Region": "${data['aws_cognito_region']}"
            }
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH",
            "passwordProtectionSettings": {
              "passwordPolicyMinLength": 8,
              "passwordPolicyCharacters": [
                "REQUIRES_NUMBERS",
                "REQUIRES_LOWERCASE",
                "REQUIRES_UPPERCASE",
                "REQUIRES_SYMBOLS"
              ]
            },
            "signupAttributes": [
              "EMAIL"
            ],
            "usernameAttributes": [
              "EMAIL"
            ],
            "verificationMechanisms": [
              "EMAIL"
            ]
          }
        },
        "AppSync": {
          "Default": {
            "ApiUrl": "${data['aws_appsync_graphqlEndpoint']}",
            "Region": "${data['aws_appsync_region']}",
            "AuthMode":  "${data['aws_appsync_authenticationType']}",
            "ClientDatabasePrefix": "data_AMAZON_COGNITO_USER_POOLS"
          },
          "AWS_IAM": {
            "ApiUrl": "${data['aws_appsync_graphqlEndpoint']}",
            "Region": "${data['aws_appsync_region']}",
            "AuthMode":  "${data['aws_appsync_authenticationType']}",
            "ClientDatabasePrefix": "data_AWS_IAM"
          }
        }
      }
    }
  },
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        "data": {
          "endpointType": "GraphQL",
          "endpoint": "${data['aws_appsync_graphqlEndpoint']}",
          "region": "${data['aws_appsync_region']}",
          "authorizationType": "AMAZON_COGNITO_USER_POOLS"
        }
      }
    }
  },
  "storage": {
    "plugins": {
      "awsS3StoragePlugin": {
        "bucket": "${data['aws_user_files_s3_bucket']}",
        "region": "${data['aws_user_files_s3_bucket_region']}"
      }
    }
  }
}''';
  }

  static Future<String> getConfigFromJson2() async {
    final String jsonString =
        await rootBundle.loadString('lib/amplify_outputs.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    CognitoUserPoolConfig cognitoUserPoolConfig = CognitoUserPoolConfig(
        poolId: data['auth']['user_pool_id'],
        appClientId: data['auth']['user_pool_client_id'],
        region: data['auth']['aws_region']);
    CognitoIdentityPoolConfig cognitoIdentityPoolConfig =
        CognitoIdentityPoolConfig(
            poolId: data['auth']['identity_pool_id'],
            region: data['auth']['aws_region']);

    List<CognitoUserAttributeKey> usernameAttributes = [];
    for (final usernameAttribute in data['auth']['username_attributes']) {
      usernameAttributes.add(CognitoUserAttributeKey.parse(usernameAttribute));
    }

    List<CognitoUserAttributeKey> signupAttributes = [];
    for (final signupAttribute in data['auth']
        ['standard_required_attributes']) {
      signupAttributes.add(CognitoUserAttributeKey.parse(signupAttribute));
    }

    List<CognitoUserAttributeKey> verificationMechanisms = [];
    for (final verificationMechanism in data['auth']
        ['user_verification_types']) {
      verificationMechanisms
          .add(CognitoUserAttributeKey.parse(verificationMechanism));
    }

    final passwordPolicy =
        data['auth']['password_policy'] as Map<String, dynamic>;

    Map<String, dynamic> passwordProtectionSettingsJson = <String, dynamic>{};

    if (passwordPolicy.containsKey('min_length')) {
      passwordProtectionSettingsJson['min_length'] =
          passwordPolicy['min_length'];
    }

    List<String> passwordPolicies = [];
    passwordPolicy.forEach((k, v) {
      if (v == true) {
        passwordPolicies
            .add(k.toUpperCase().replaceFirst('REQUIRE', 'REQUIRES'));
      }
    });

    passwordProtectionSettingsJson['passwordPolicyCharacters'] =
        passwordPolicies;

    PasswordProtectionSettings passwordProtectionSettings =
        PasswordProtectionSettings.fromJson(passwordProtectionSettingsJson);

    AuthConfig authConfig = AuthConfig.cognito(
      userPoolConfig: cognitoUserPoolConfig,
      identityPoolConfig: cognitoIdentityPoolConfig,
      usernameAttributes: usernameAttributes,
      signupAttributes: signupAttributes,
      verificationMechanisms: verificationMechanisms,
      passwordProtectionSettings: passwordProtectionSettings,
    );

    Map<String, CognitoAppSyncConfig> cognitoAppSyncConfig = {
      'Default': CognitoAppSyncConfig(
          apiUrl: data['data']['url'],
          region: data['data']['aws_region'],
          authMode: toAPIAuthorizationType(
              data['data']['default_authorization_type']),
          clientDatabasePrefix:
              'data_${data['data']['default_authorization_type']}')
    };

    for (final authorizationtype in data['data']['authorization_types']) {
      CognitoAppSyncConfig appSyncConfig = CognitoAppSyncConfig(
          apiUrl: data['data']['url'],
          region: data['data']['aws_region'],
          authMode: toAPIAuthorizationType(authorizationtype),
          clientDatabasePrefix: 'data_$authorizationtype');
      cognitoAppSyncConfig['data_$authorizationtype'] = appSyncConfig;
    }

    CognitoPluginConfig extendedAuthConfigPlugin = authConfig.awsPlugin!
        .copyWith(appSync: AWSConfigMap(cognitoAppSyncConfig));

    Map<String, AWSApiConfig> endpoints = {
      'Default': AWSApiConfig(
          endpointType: EndpointType.graphQL,
          endpoint: data['data']['url'],
          region: data['data']['aws_region'],
          authorizationType: toAPIAuthorizationType(
              data['data']['default_authorization_type']))
    };

    AWSApiPluginConfig awsApiPluginConfig = AWSApiPluginConfig(endpoints);

    ApiConfig apiConfig =
        ApiConfig(plugins: {'awsAPIPlugin': awsApiPluginConfig});

    S3PluginConfig s3PluginConfig = S3PluginConfig(
        bucket: data['storage']['bucket_name'],
        region: data['storage']['aws_region']);

    StorageConfig storageConfig =
        StorageConfig(plugins: {'awsS3StoragePlugin': s3PluginConfig});

    AmplifyConfig amplifyConfig = AmplifyConfig(
        userAgent: "@aws-amplify/client-config/1.0.2",
        auth: AuthConfig(
            plugins: {CognitoPluginConfig.pluginKey: extendedAuthConfigPlugin}),
        api: apiConfig,
        storage: storageConfig);

    return jsonEncode(amplifyConfig);
  }

  static APIAuthorizationType toAPIAuthorizationType(String string) {
    if (string == "AMAZON_COGNITO_USER_POOLS") {
      return APIAuthorizationType.userPools;
    }
    if (string == "AWS_IAM") {
      return APIAuthorizationType.iam;
    }
    throw "Unknown APIAuthorizationType";
  }

  static Future<String> getConfigFromJson3() async {
    final String jsonString =
        await rootBundle.loadString('lib/amplify_outputs.json');
    final AmplifyOutput amplifyOutput =
        AmplifyOutput.fromJson(jsonDecode(jsonString));

    StorageConfig? storageConfig;
    ApiConfig? apiConfig;

    switch (amplifyOutput.data) {
      case Data data:
        {
          apiConfig = ApiConfig(plugins: {
            AWSApiPluginConfig.pluginKey: AWSApiPluginConfig({
              AWSApiPluginConfig.pluginKey: AWSApiConfig(
                  endpointType: EndpointType.graphQL,
                  endpoint: data.url,
                  region: data.awsRegion,
                  authorizationType: AmplifyAuthProviderToken<
                              TokenIdentityAmplifyAuthProvider>(
                          data.defaultAuthorizationType.toString())
                      as APIAuthorizationType)
            })
          });
        }
    }

    switch (amplifyOutput.storage) {
      case Storage storage:
        {
          storageConfig = StorageConfig(plugins: {
            S3PluginConfig.pluginKey: S3PluginConfig(
                bucket: storage.bucketName, region: storage.awsRegion)
          });
        }
    }

    AmplifyConfig amplifyConfig = AmplifyConfig(
        userAgent: "@aws-amplify/client-config/1.0.2",
        api: apiConfig,
        storage: storageConfig);

    return jsonEncode(amplifyConfig);
  }
}
