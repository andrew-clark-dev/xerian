import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';

main() {
  const jsonString = '''
  {
  "auth": {
    "user_pool_id": "eu-central-1_HA68L0703",
    "aws_region": "eu-central-1",
    "user_pool_client_id": "569kpsrai1lepl02kjijp351ag",
    "identity_pool_id": "eu-central-1:4c9910c1-6915-4b16-9177-8df9e910c3fa",
    "standard_required_attributes": [
      "email"
    ],
    "username_attributes": [
      "email"
    ],
    "user_verification_types": [
      "email"
    ],
    "password_policy": {
      "min_length": 8,
      "require_numbers": true,
      "require_lowercase": true,
      "require_uppercase": true,
      "require_symbols": true
    },
    "unauthenticated_identities_enabled": true
  },
  "data": {
    "url": "https://dzl26khhtzg75pwyfzsjircpki.appsync-api.eu-central-1.amazonaws.com/graphql",
    "aws_region": "eu-central-1",
    "default_authorization_type": "AMAZON_COGNITO_USER_POOLS",
    "authorization_types": [
      "AWS_IAM"
    ],
    "model_introspection": {
      "version": 1,
      "models": {
        "Counter": {
          "name": "Counter",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "count": {
              "name": "count",
              "isArray": false,
              "type": "Int",
              "isRequired": false,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Counters",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Account": {
          "name": "Account",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "number": {
              "name": "number",
              "isArray": false,
              "type": "Int",
              "isRequired": true,
              "attributes": []
            },
            "firstName": {
              "name": "firstName",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "lastName": {
              "name": "lastName",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "email": {
              "name": "email",
              "isArray": false,
              "type": "AWSEmail",
              "isRequired": false,
              "attributes": []
            },
            "phoneNumber": {
              "name": "phoneNumber",
              "isArray": false,
              "type": "AWSPhone",
              "isRequired": false,
              "attributes": []
            },
            "address": {
              "name": "address",
              "isArray": true,
              "type": "String",
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true
            },
            "city": {
              "name": "city",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "state": {
              "name": "state",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "postcode": {
              "name": "postcode",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "split": {
              "name": "split",
              "isArray": false,
              "type": "Int",
              "isRequired": false,
              "attributes": []
            },
            "items": {
              "name": "items",
              "isArray": true,
              "type": {
                "model": "Item"
              },
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true,
              "association": {
                "connectionType": "HAS_MANY",
                "associatedWith": [
                  "accountId"
                ]
              }
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Accounts",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Item": {
          "name": "Item",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "sku": {
              "name": "sku",
              "isArray": false,
              "type": "Int",
              "isRequired": true,
              "attributes": []
            },
            "accountId": {
              "name": "accountId",
              "isArray": false,
              "type": "ID",
              "isRequired": false,
              "attributes": []
            },
            "account": {
              "name": "account",
              "isArray": false,
              "type": {
                "model": "Account"
              },
              "isRequired": false,
              "attributes": [],
              "association": {
                "connectionType": "BELONGS_TO",
                "targetNames": [
                  "accountId"
                ]
              }
            },
            "categories": {
              "name": "categories",
              "isArray": true,
              "type": {
                "model": "ItemCategory"
              },
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true,
              "association": {
                "connectionType": "HAS_MANY",
                "associatedWith": [
                  "itemId"
                ]
              }
            },
            "description": {
              "name": "description",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "details": {
              "name": "details",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "images": {
              "name": "images",
              "isArray": true,
              "type": "AWSURL",
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true
            },
            "quality": {
              "name": "quality",
              "isArray": false,
              "type": {
                "enum": "ItemQuality"
              },
              "isRequired": false,
              "attributes": []
            },
            "split": {
              "name": "split",
              "isArray": false,
              "type": "Int",
              "isRequired": false,
              "attributes": []
            },
            "status": {
              "name": "status",
              "isArray": false,
              "type": {
                "enum": "ItemStatus"
              },
              "isRequired": false,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Items",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "ItemCategory": {
          "name": "ItemCategory",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "itemId": {
              "name": "itemId",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "categoryId": {
              "name": "categoryId",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "item": {
              "name": "item",
              "isArray": false,
              "type": {
                "model": "Item"
              },
              "isRequired": false,
              "attributes": [],
              "association": {
                "connectionType": "BELONGS_TO",
                "targetNames": [
                  "itemId"
                ]
              }
            },
            "category": {
              "name": "category",
              "isArray": false,
              "type": {
                "model": "Category"
              },
              "isRequired": false,
              "attributes": [],
              "association": {
                "connectionType": "BELONGS_TO",
                "targetNames": [
                  "categoryId"
                ]
              }
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "ItemCategories",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Category": {
          "name": "Category",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "type": {
              "name": "type",
              "isArray": false,
              "type": {
                "enum": "CategoryType"
              },
              "isRequired": false,
              "attributes": []
            },
            "items": {
              "name": "items",
              "isArray": true,
              "type": {
                "model": "ItemCategory"
              },
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true,
              "association": {
                "connectionType": "HAS_MANY",
                "associatedWith": [
                  "categoryId"
                ]
              }
            },
            "value": {
              "name": "value",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Categories",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "key",
              "properties": {
                "name": "categoriesByType",
                "queryField": "listCategoryByType",
                "fields": [
                  "type"
                ]
              }
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Sale": {
          "name": "Sale",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "number": {
              "name": "number",
              "isArray": false,
              "type": "Int",
              "isRequired": false,
              "attributes": []
            },
            "status": {
              "name": "status",
              "isArray": false,
              "type": {
                "enum": "SaleStatus"
              },
              "isRequired": false,
              "attributes": []
            },
            "finalized": {
              "name": "finalized",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": []
            },
            "total": {
              "name": "total",
              "isArray": false,
              "type": "Float",
              "isRequired": false,
              "attributes": []
            },
            "subtotal": {
              "name": "subtotal",
              "isArray": false,
              "type": "Float",
              "isRequired": false,
              "attributes": []
            },
            "paymentType": {
              "name": "paymentType",
              "isArray": false,
              "type": {
                "enum": "SalePaymentType"
              },
              "isRequired": false,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Sales",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Refund": {
          "name": "Refund",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "number": {
              "name": "number",
              "isArray": false,
              "type": "Int",
              "isRequired": false,
              "attributes": []
            },
            "status": {
              "name": "status",
              "isArray": false,
              "type": {
                "enum": "RefundStatus"
              },
              "isRequired": false,
              "attributes": []
            },
            "finalized": {
              "name": "finalized",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": []
            },
            "total": {
              "name": "total",
              "isArray": false,
              "type": "Float",
              "isRequired": false,
              "attributes": []
            },
            "subtotal": {
              "name": "subtotal",
              "isArray": false,
              "type": "Float",
              "isRequired": false,
              "attributes": []
            },
            "paymentType": {
              "name": "paymentType",
              "isArray": false,
              "type": {
                "enum": "RefundPaymentType"
              },
              "isRequired": false,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Refunds",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Journal": {
          "name": "Journal",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "modelId": {
              "name": "modelId",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "timestamp": {
              "name": "timestamp",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": true,
              "attributes": []
            },
            "action": {
              "name": "action",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "before": {
              "name": "before",
              "isArray": false,
              "type": "AWSJSON",
              "isRequired": false,
              "attributes": []
            },
            "after": {
              "name": "after",
              "isArray": false,
              "type": "AWSJSON",
              "isRequired": false,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Journals",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Tag": {
          "name": "Tag",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "modelId": {
              "name": "modelId",
              "isArray": false,
              "type": "ID",
              "isRequired": false,
              "attributes": []
            },
            "key": {
              "name": "key",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "value": {
              "name": "value",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Tags",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        }
      },
      "enums": {
        "ItemQuality": {
          "name": "ItemQuality",
          "values": [
            "asNew",
            "good",
            "marked"
          ]
        },
        "ItemStatus": {
          "name": "ItemStatus",
          "values": [
            "tagged",
            "hungOut",
            "sold",
            "toDonate",
            "donated"
          ]
        },
        "CategoryType": {
          "name": "CategoryType",
          "values": [
            "department",
            "colour",
            "brand",
            "size"
          ]
        },
        "SaleStatus": {
          "name": "SaleStatus",
          "values": [
            "parked",
            "finalized"
          ]
        },
        "SalePaymentType": {
          "name": "SalePaymentType",
          "values": [
            "cash",
            "card",
            "giftCard",
            "accountCredit"
          ]
        },
        "RefundStatus": {
          "name": "RefundStatus",
          "values": [
            "parked",
            "finalized"
          ]
        },
        "RefundPaymentType": {
          "name": "RefundPaymentType",
          "values": [
            "cash",
            "accountCredit"
          ]
        }
      },
      "nonModels": {},
      "mutations": {
        "incrementCounter": {
          "name": "incrementCounter",
          "isArray": false,
          "type": {
            "model": "Counter"
          },
          "isRequired": false,
          "arguments": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": false
            }
          }
        }
      }
    }
  },
  "storage": {
    "aws_region": "eu-central-1",
    "bucket_name": "amplify-xerian-andrew-sandb-appfilesbucket23865b9a-hoh7eesi4qqg"
  },
  "version": "1"
} 
  ''';

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
  for (final signupAttribute in data['auth']['standard_required_attributes']) {
    signupAttributes.add(CognitoUserAttributeKey.parse(signupAttribute));
  }

  List<CognitoUserAttributeKey> verificationMechanisms = [];
  for (final verificationMechanism in data['auth']['user_verification_types']) {
    verificationMechanisms
        .add(CognitoUserAttributeKey.parse(verificationMechanism));
  }

  final passwordPolicy =
      data['auth']['password_policy'] as Map<String, dynamic>;

  Map<String, dynamic> passwordProtectionSettingsJson = <String, dynamic>{};

  if (passwordPolicy.containsKey('min_length')) {
    passwordProtectionSettingsJson['min_length'] = passwordPolicy['min_length'];
  }

  List<String> passwordPolicies = [];
  passwordPolicy.forEach((k, v) {
    if (v == true) {
      passwordPolicies.add(k.toUpperCase().replaceFirst('REQUIRE', 'REQUIRES'));
    }
  });

  passwordProtectionSettingsJson['passwordPolicyCharacters'] = passwordPolicies;

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

  AWSApiConfig defaultAwsApiConfig = AWSApiConfig(
      endpointType: EndpointType.graphQL,
      endpoint: data['data']['url'],
      region: data['data']['aws_region'],
      authorizationType:
          toAPIAuthorizationType(data['data']['default_authorization_type']));

  Map<String, AWSApiConfig> endpoints = <String, AWSApiConfig>{};
  endpoints['Default'] = defaultAwsApiConfig;

  for (final authorizationtype in data['data']['authorization_types']) {
    AWSApiConfig awsApiConfig = AWSApiConfig(
        endpointType: EndpointType.graphQL,
        endpoint: data['data']['url'],
        region: data['data']['aws_region'],
        authorizationType: toAPIAuthorizationType(authorizationtype));
    endpoints['data_$authorizationtype'] = awsApiConfig;
  }

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
      auth: authConfig,
      api: apiConfig,
      storage: storageConfig);

  print(jsonEncode(amplifyConfig));
}

APIAuthorizationType toAPIAuthorizationType(String string) {
  if (string == "AMAZON_COGNITO_USER_POOLS") {
    return APIAuthorizationType.userPools;
  }
  if (string == "AWS_IAM") {
    return APIAuthorizationType.iam;
  }
  throw "Unknown APIAuthorizationType";
}
