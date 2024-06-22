import 'package:amplify_core/amplify_core.dart';
import 'package:xerian/models/ModelProvider.dart';

extension ModelTypeExtensions on ModelType {
  String path() => '/${modelName().toLowerCase()}';
  String listPath() => '/${modelName().toLowerCase()}list';
  String formPath() => '/${modelName().toLowerCase()}form';

  ModelSchema schema() {
    return ModelProvider.instance.modelSchemas
        .firstWhere((e) => e.name == modelName());
  }
}

extension ModelFieldExtensions on ModelField {
  ModelFieldTypeEnum fieldType() => type.fieldType;
  bool isString() => fieldType() == ModelFieldTypeEnum.string;
}
