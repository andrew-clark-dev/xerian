import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../models/Account.dart';
import '../routable.dart';

class AdminSettings extends StatelessWidget implements Routable {
  @override
  String get path => '/admin';

  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administration')),
      body: SettingsList(
        platform: DevicePlatform.web,
        sections: [
          SettingsSection(
            title: const Text('Auto-fill'),
            tiles: [
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.vpn_key),
                title: const Text('Passwords'),
              ),
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.credit_card_outlined),
                title: const Text('Payment methods'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Custom actions'),
            tiles: [
              SettingsTile(
                  title: const Text('Import accounts'),
                  leading: const Icon(Icons.warning_amber),
                  description: const Text('Import accounts from excel sheet.'),
                  onPressed: (_) {}),
              SettingsTile.navigation(
                onPressed: (_) async => processFile(),
                leading: const Icon(Icons.warning_amber),
                title: const Text('Set ad preferences'),
                description: const Text(
                    'Set the account ad preferences based on a list of account numbers'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const graphQLDocument = '''
      query listAccountByNumber(\$number: String!) {
        listAccountByNumber(number: \$number) {
            items {
              firstName
              lastName
              number
              id
              address
              adprefs
              balance
              city
              createdAt
              email
              isMobile
              original
              phoneNumber
              postcode
              state
              status
              updatedAt
          }
        }
      }
    ''';

  static const graphQLDocument2 = '''
query listAccounts(\$filter: ModelAccountFilterInput, \$limit: Int, \$nextToken: String) { 
listAccounts(filter: \$filter, limit: \$limit, nextToken: \$nextToken) { 
items { 
  id 
  number 
  firstName 
  lastName 
  email 
  phoneNumber 
  isMobile 
  address 
  city 
  state 
  postcode 
  balance 
  adprefs 
  status 
  original 
  createdAt 
  updatedAt } 
nextToken } 
}
''';

  /// Atomically increment the counter for the given model (or modelName) and return the incremented value
  Future<Account> getByNumber(String number) async {
    final incRequest = GraphQLRequest<Account>(
        document: graphQLDocument,
        variables: <String, String>{"number": number},
        modelType: Account.classType);

    final response = await Amplify.API.query(request: incRequest).response;
    final count = response.data!;
    return count;
  }

  Future<void> processFile() async {
    NumberFormat formatter = NumberFormat("000000");

    var i = 0;

    var result = await FilePicker.platform.pickFiles();
    if (result != null) {
      var content = result.files.single.bytes!;
      var lines = LineSplitter.split(const Utf8Decoder().convert(content));
      for (var line in lines) {
        var key = line.split(',')[0].trim();
        if (key.isNotEmpty) {
          var number = formatter.format(int.parse(key));

          final queryPredicate = Account.NUMBER.eq(number);

          final request = ModelQueries.list<Account>(
            Account.classType,
            where: queryPredicate,
          );

          request.modelType;

          // final response = await Amplify.API.query(request: request).response;

          // print('Response - $response');

          final incRequest = GraphQLRequest<PaginatedResult<Account>>(
              document: graphQLDocument,
              variables: <String, String>{"number": number},
              decodePath: 'listAccountByNumber',
              modelType: const PaginatedModelType(Account.classType));

          final incresponse =
              await Amplify.API.query(request: incRequest).response;

          print('Response - $incresponse');

          i += i;

          if (i > 10) {
            break;
          }
        }
      }
    }
  }
}
