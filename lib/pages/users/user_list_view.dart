import 'package:aws_client/cognito_identity_provider_2016_04_18.dart';
import 'package:logging/logging.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:xerian/widgets/model_list_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

const limit = 20;

final Logger log = Logger("UserListView");

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  // ignore: library_private_types_in_public_api,
  UserListViewState createState() => UserListViewState();
}

class UserListViewState extends ModelListViewState {
  /// Overide this method to control the fetching of the model data.
  /// e.g. fetch from a non amplify source and convert to amplify mode for displaying.
  // Future<PaginatedResult<Model>?> fetch(PaginatedResult<Model>? page) async {
  //   final api = CognitoIdentityProvider(region: dotenv.env['AWS_REGION']!);
  //   api.

  //   Amplify.Auth.fetchUserAttributes().
  //     try {
  //   await api.listUsers(userPoolId: userPoolId).adminDeleteUser(userPoolId: cognitoPool, username: user);
  // } on ResourceNotFoundException catch (_) {
  //   // ok
  // }
  // }
}
