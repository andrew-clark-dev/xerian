import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final userPool = CognitoUserPool(
    '${(dotenv.env['POOL_ID'])}',
    '${(dotenv.env['CLIENT_ID'])}',
  );

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onSubmitAnimationCompleted: () {
        context.go('/dashboard');
      },
      onSignup: _signupUser,
      onConfirmSignup: _signupConfirm,
      onResendCode: _resendCode,
      onLogin: _loginUser,
      onRecoverPassword: _recoverPassword,
      onConfirmRecover: _recoverConfirm,
    );
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup info');
    debugPrint('Name: ${data.name}');
    debugPrint('Password: ${data.password}');
    if (data.termsOfService.isNotEmpty) {
      debugPrint('Terms of service: ');
      for (final element in data.termsOfService) {
        debugPrint(
          ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}',
        );
      }
    }

    try {
      // Sign up the user
      await userPool.signUp(data.name!, data.password!);
      // Signup successful, move on to confirmation
      return null;
    } on CognitoClientException catch (e) {
      // Authentication failed, return error message
      return e.message;
    }
  }

  Future<String?> _resendCode(SignupData data) async {
    debugPrint('Resend code');
    debugPrint('Name: ${data.name}');
    debugPrint('Password: ${data.password}');
    final cognitoUser = CognitoUser(data.name, userPool);
    try {
      // Sign up the user
      await cognitoUser.resendConfirmationCode();
      // Resend successful
      return null;
    } on CognitoClientException catch (e) {
      // Authentication failed, return error message
      return e.message;
    }
  }

  Future<String?> _signupConfirm(String code, LoginData data) async {
    debugPrint('Confirm info');
    debugPrint('Name: ${data.name}');
    debugPrint('Password: ${data.password}');
    debugPrint('Code: $code');
    final cognitoUser = CognitoUser(data.name, userPool);
    try {
      // Confirm the signup with the provided confirmation code
      await cognitoUser.confirmRegistration(code);
      // Confirm successful, navigate to home screen
      return null;
    } on CognitoClientException catch (e) {
      // Confirmation failed, return error message
      return e.message;
    }
  }

  Future<String?> _loginUser(LoginData data) async {
    debugPrint('Login info');
    debugPrint('Name: ${data.name}');
    debugPrint('Password: ${data.password}');

    final cognitoUser = CognitoUser(data.name, userPool);
    final authDetails = AuthenticationDetails(
      username: data.name,
      password: data.password,
    );
    CognitoUserSession session;
    try {
      session = (await cognitoUser.authenticateUser(authDetails))!;
      debugPrint(session.getAccessToken().getJwtToken());
      // Authentication successful, navigate to home screen
      return null;
    } on CognitoClientException catch (e) {
      // handle Wrong Username and Password and Cognito Client
      return e.message;
    }
  }

  Future<String?> _recoverPassword(String name) async {
    debugPrint('Recover password info');
    debugPrint('Name: $name');
    final cognitoUser = CognitoUser(name, userPool);
    try {
      await cognitoUser.forgotPassword();
      return null;
    } on CognitoClientException catch (e) {
      // handle Wrong Username and Password and Cognito Client
      return e.message;
    }
  }

  Future<String?> _recoverConfirm(String code, LoginData data) async {
    debugPrint('Confirm info');
    debugPrint('Name: ${data.name}');
    debugPrint('Password: ${data.password}');
    debugPrint('Code: $code');
    final cognitoUser = CognitoUser(data.name, userPool);
    try {
      // Confirm the recovery with the provided confirmation code
      await cognitoUser.confirmPassword(code, data.password);
      // Confirm successful, navigate to home screen
      return null;
    } on CognitoClientException catch (e) {
      // Confirmation failed, return error message
      return e.message;
    }
  }
}
