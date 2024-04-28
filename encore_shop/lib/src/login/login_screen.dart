import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

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
      onSignup: _signupUser,
      onConfirmSignup: _signupConfirm,
      onResendCode: _resendCode,
      onLogin: (loginData) {
        return _loginUser(loginData);
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      onConfirmRecover: _signupConfirm,
    );
  }

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

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
      // Authentication successful, navigate to home screen
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
    debugPrint('AdditionalSignupData: ${data.additionalSignupData}');
    try {
      // Sign up the user
//      await userPool.signUp(data.name!, data.password!);
      // Authentication successful, navigate to home screen
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
      // Authentication successful, navigate to home screen
      return null;
    } on CognitoClientException catch (e) {
      // Confirmation failed, return error message
      return e.message;
    }
  }

  Future<String?> _loginUser(LoginData data) {
    debugPrint('Login info');
    debugPrint('Name: ${data.name}');
    debugPrint('Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }
}
