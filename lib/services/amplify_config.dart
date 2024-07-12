import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:xerian/amplifyconfiguration.dart';

class AmplifyConfig {
  final AmplifyOutputs amplifyOutputs =
      AmplifyOutputs.fromJson(jsonDecode(amplifyConfig));
}
