import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:aws_lambda_api/lambda-2015-03-31.dart';

extension AuthExtensions on AuthCategory {
  Future<bool> get isAuthorized async {
    try {
      final result = await fetchAuthSession();
      safePrint('User is signed in: ${result.isSignedIn}');
      return result.isSignedIn;
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
      return false;
    }
  }

  Future<AwsClientCredentials> get awsClientCredentials async {
    CognitoAuthSession session =
        await getPlugin(AmplifyAuthCognito.pluginKey).fetchAuthSession();
    AWSCredentials credentials = session.credentialsResult.value;

    AwsClientCredentials awsClientCredentials = AwsClientCredentials(
        accessKey: credentials.accessKeyId,
        secretKey: credentials.secretAccessKey,
        sessionToken: credentials.sessionToken,
        expiration: credentials.expiration);

    return awsClientCredentials;
  }

  Future<CognitoAuthUser> get cognitoAuthUser async {
    CognitoAuthUser cognitoAuthUser =
        await getPlugin(AmplifyAuthCognito.pluginKey).getCurrentUser();
    return cognitoAuthUser;
  }

  Future<bool> get hasAdminPrivilages async {
    try {
      final CognitoAuthSession session =
          await getPlugin(AmplifyAuthCognito.pluginKey).fetchAuthSession();

      final JsonWebToken idToken = session.userPoolTokensResult.value.idToken;

      safePrint("Current user's id token: $idToken");

      return idToken.groups.contains('ADMINS');
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
      rethrow;
    }
  }
}
