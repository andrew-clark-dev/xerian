import 'package:amplify_core/amplify_core.dart';

import '../models/ModelProvider.dart';

extension ModelTypeExtensions on ModelType {
  String get viewPath => '/${modelName().toLowerCase()}';
  String get listPath => '/${modelName().toLowerCase()}list';
  String get formPath => '/${modelName().toLowerCase()}form';

  ModelSchema get schema => ModelProvider.instance.modelSchemas.firstWhere((e) => e.name == modelName());
}
