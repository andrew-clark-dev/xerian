import 'dart:convert';
import 'package:flutter/services.dart';

class AmplifyConfigService {
  static getConfigFromJson() async {
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
            "ClientDatabasePrefix": "data_AWS_IAM"
          },
          "data_AMAZON_COGNITO_USER_POOLS": {
            "ApiUrl": "${data['aws_appsync_graphqlEndpoint']}",
            "Region": "${data['aws_appsync_region']}",
            "AuthMode":  "${data['aws_appsync_authenticationType']}",
            "ClientDatabasePrefix": "data_AMAZON_COGNITO_USER_POOLS"
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
          "authorizationType": "AWS_IAM"
        }
      }
    }
  }
}''';
  }
}
