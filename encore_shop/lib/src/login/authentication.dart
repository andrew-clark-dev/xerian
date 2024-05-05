import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Authentication {
  static Authentication? _instance;

  CognitoUserPool _userPool;

  CognitoUser _user;

  AuthenticationDetails _authDetails;

  CognitoUserSession _session;

  CognitoCredentials _credentials;

  AwsClientCredentials _clientCredentials;

  factory Authentication() {
    if (_instance == null) {
      throw Exception("Not logged in.");
    } else {
      return _instance!;
    }
  }

  Authentication._privateConstructor(
      this._userPool,
      this._user,
      this._authDetails,
      this._session,
      this._credentials,
      this._clientCredentials);

  get userPool => _userPool;
  get user => _user;
  get authDetails => _authDetails;
  get session => _session;
  get credentials => _credentials;
  get clientCredentials => _clientCredentials;

  static void login(name, password) async {
    final userPool = CognitoUserPool(
      '${(dotenv.env['POOL_ID'])}',
      '${(dotenv.env['CLIENT_ID'])}',
    );

    final user = CognitoUser(name, userPool);

    final authDetails = AuthenticationDetails(
      username: name,
      password: password,
    );

    final session = (await user.authenticateUser(authDetails))!;

    var credentials =
        CognitoCredentials('${(dotenv.env['IDENTITY_POOL_ID'])}', userPool);
    await credentials.getAwsCredentials(session.getIdToken().getJwtToken());

    final clientCredentials = AwsClientCredentials(
        accessKey: credentials.accessKeyId!,
        secretKey: credentials.secretAccessKey!,
        sessionToken: credentials.sessionToken);

    _instance = Authentication._privateConstructor(
        userPool, user, authDetails, session, credentials, clientCredentials);
  }
}
