import 'package:amplify_core/amplify_core.dart';
import 'package:xerian/model_config.dart';
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
  bool isText() => !{ModelFieldTypeEnum.bool, ModelFieldTypeEnum.enumeration}
      .contains(fieldType());
  bool isBool() => fieldType() == ModelFieldTypeEnum.bool;
  bool isEnum() => fieldType() == ModelFieldTypeEnum.enumeration;
}

extension ModelExtensions on Model {
  List<ModelField> viewFields() => ModelConfig(getInstanceType()).viewFields();
}
