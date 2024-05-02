import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class Authentication {
  Authentication._privateConstructor();

  static final Authentication _instance = Authentication._privateConstructor();

  factory Authentication() {
    return _instance;
  }

  CognitoUserSession? session;

  bool isAuthenticated() {
    return session != null;
  }
}
