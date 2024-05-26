import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';

class AmplifyConfigService {
  static Future<String> getConfigFromJson2() async {
    final String jsonString =
        await rootBundle.loadString('lib/amplifyconfiguration.json');

    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    AmplifyConfig amplifyConfig = AmplifyConfig.fromJson(data);

    // CognitoUserPoolConfig cognitoUserPoolConfig = CognitoUserPoolConfig(
    //     poolId: data['aws_user_pools_id'],
    //     appClientId: data['aws_user_pools_web_client_id'],
    //     region: data['aws_cognito_region']);

    // CognitoIdentityCredentialsProvider cognitoIdentityCredentialsProvider =
    //     CognitoIdentityCredentialsProvider(
    //         poolId: data['aws_cognito_identity_pool_id'],
    //         region: data['aws_cognito_region']);

    // PasswordProtectionSettings passwordProtectionSettings =
    //     PasswordProtectionSettings.fromJson(
    //         data['aws_cognito_password_protection_settings']);

    final json = amplifyConfig.toJson();

    return jsonEncode(json);
  }

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
}
