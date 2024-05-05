// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';

import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

import 'package:encore_shop/src/login/authentication.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'account.dart';

class AccountView extends StatefulWidget {
  const AccountView({
    required this.account,
    super.key,
  });

  final Account? account;

  @override
  State<AccountView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  late final String _titleText;

  bool get _isCreate => _account == null;
  Account? get _account => widget.account;

  @override
  void initState() {
    super.initState();

    final account = _account;
    if (account != null) {
      _firstNameController.text = account.firstName;
      _lastNameController.text = account.lastName;
      _numberController.text = account.number.toStringAsFixed(2);
      _titleText = 'Update account';
    } else {
      _titleText = 'Create account';
      // asyncInitState();
    }
  }

  // void asyncInitState() async {
  //   _numberController.text =
  //       await CounterService().getNextValueAsString('account');
  // }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // If the form is valid, submit the data
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final number = int.parse(_numberController.text);

    if (_isCreate) {
      // Create a new account entry
      final newEntry = Account(
        firstName: firstName,
        lastName: lastName,
        number: number,
      );

      final service = DynamoDB(
          region: 'eu-central-1',
          credentials: Authentication().clientCredentials);

      await service.putItem(tableName: 'xerian-account-entity-dev', item: {
        'id': AttributeValue(s: newEntry.id),
        'number': AttributeValue(n: newEntry.number.toString()),
        'data': AttributeValue(s: jsonEncode(newEntry))
      });

      // try {
      //   final cognitoPlugin =
      //       Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      //   final result = await cognitoPlugin.fetchAuthSession();
      //   String apiUrl =
      //       'https://jgy6ezt901.execute-api.eu-central-1.amazonaws.com/dev/account';
      //   String? accessToken = result.credentialsResult.value.sessionToken;

      //   final response = await http.post(
      //     Uri.parse(apiUrl),
      //     headers: {
      //       HttpHeaders.contentTypeHeader: "application/json",
      //       HttpHeaders.authorizationHeader: "Bearer $accessToken"
      //     },
      //     body: jsonEncode(newEntry),
      //   );
      //   print('response: ' + response.toString());
      // } catch (e) {
      //   print('exception: ' + e.toString());
      // }
      // final request = ModelMutations.create(newEntry);
      // final response = await Amplify.API.mutate(request: request).response;
      // safePrint('Create result: $response');
    } else {
      // Update account instead
      final updateAccount = _account!.copyWith(
        firstName: firstName,
        lastName: lastName.isNotEmpty ? lastName : null,
      );
      // final request = ModelMutations.update(updateAccount);
      // final response = await Amplify.API.mutate(request: request).response;
      // safePrint('Update result: $response');
    }

    // Navigate back to homepage after create/update executes
    if (mounted) {
      //     context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'Title (required)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    TextFormField(
                      controller: _numberController,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Amount (required)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: submitForm,
                      child: Text(_titleText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
