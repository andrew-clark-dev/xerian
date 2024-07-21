import 'dart:convert';
import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:test/test.dart';

main() {
  test('Read config', () async {
    final file = File('test/amplify-config-test/amplify_outputs.json');
    expect(file, isNotNull);
    var json = jsonDecode(await file.readAsString());

    Map<String, dynamic> restApiConfig = {
      'mykey': {
        'aws_region': 'a-region',
        'url': 'a url',
        'authorization_type': 'AMAZON_COGNITO_USER_POOLS'
      }
    };

    json['rest_api'] = restApiConfig;

    final AmplifyOutputs amplifyOutput = AmplifyOutputs.fromJson(json);
    safePrint(amplifyOutput.custom);
    safePrint(amplifyOutput.props[5]);

    expect(amplifyOutput, isNotNull);
  });
}
