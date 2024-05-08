import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:encore_shop/src/login/authentication.dart';
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
        context.go('/accounts');
      },
      onSignup: _signupUser,
      onConfirmSignup: _signupConfirm,
      onResendCode: _resendCode,
      onLogin: _loginUser,
      onRecoverPassword: _recoverPassword,
      onConfirmRecover: _recoverConfirm,
      savedEmail: dotenv.get('SAVED_EMAIL', fallback: null),
      savedPassword: dotenv.get('SAVED_PASSWORD', fallback: null),
    );
  }

  Future<String?> _signupUser(SignupData data) async {
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
    try {
      Authentication.login(data.name, data.password);
      return null;
    } on CognitoClientException catch (e) {
      // handle Wrong Username and Password and Cognito Client
      return e.message;
    }
  }

  Future<String?> _recoverPassword(String name) async {
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
