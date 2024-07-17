import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:test/test.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/widgets/model_ui_config.dart';

main() {
  test('Write config', () {
    for (var s in ModelProvider.instance.modelSchemas) {
      final ModelUiConfig config = ModelUiConfig(s.name);
      final json = jsonEncode(config);
      final ModelUiConfig config2 = ModelUiConfig.fromJson(jsonDecode(json));
      expect(jsonEncode(config), equals(jsonEncode(config2)));
      safePrint(jsonEncode(config));
    }
  });
}
