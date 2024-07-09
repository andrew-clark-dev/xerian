import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:xerian/extensions/model_extensions.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model_ui_config.g.dart';

@JsonSerializable(explicitToJson: true)
class ModelUiConfig {
  static final Logger log = Logger("ModelUiConfig");

  static Map<String, ModelUiConfig> configurations = {};

  static Future<void> init() async {
    final String modelUiConfigJsonString =
        await rootBundle.loadString('lib/widgets/model_ui_config.json');
    if (modelUiConfigJsonString.isEmpty) {
      _dumpDefaultConfig();
    } else {
      Map<String, dynamic> modelUiConfigJson =
          jsonDecode(modelUiConfigJsonString);
      modelUiConfigJson.forEach((modelName, configJson) {
        ModelUiConfig modelUiConfig = ModelUiConfig.fromJson(configJson);
        configurations[modelName] = modelUiConfig;
      });
    }
  }

  static _dumpDefaultConfig() {
    var conf = {};
    for (var s in ModelProvider.instance.modelSchemas) {
      conf[s.name] = ModelUiConfig(s.name);
    }
    safePrint(jsonEncode(conf));
  }

  static ModelUiConfig config(ModelType modelType) {
    final result = configurations[modelType.modelName()] ??
        ModelUiConfig(modelType.modelName());
    safePrint('${modelType.modelName()} configured with ${jsonEncode(result)}');
    return result;
  }

  static final List<String> hiddenFields = ['id', 'metaData', 'original'];
  static final List<String> autosetFields = ['number', 'sku', 'balence'];

  static List<DisplayField> _defaultFields(ModelType modelType) {
    return modelType.schema.fields!.values
        .where((v) => !hiddenFields.contains(v.name))
        .map((f) =>
            DisplayField(f.name, readOnly: autosetFields.contains(f.name)))
        .toList();
  }

  // static final _config = ModelTypeUIConfig(listFields: [
  //   ListField('number'),
  //   ListField('firstName'),
  //   ListField('lastName'),
  //   ListField('phoneNumber'),
  //   ListField('email', displayName: 'E-Mail'),
  //   ListField('balance'),
  //   ListField('comunicationPreferences', displayName: 'Contact')
  // ], enumFields: [
  //   EnumField('status', AccountStatus.values),
  //   EnumField('comunicationPreferences', AccountComunicationPreferences.values),
  // ]);

  final String modelName;
  late final List<DisplayField> listFields;
  late final List<DisplayField> viewFields;

  ModelUiConfig(this.modelName, {listFields, viewFields, enumFields}) {
    this.viewFields = viewFields ?? _defaultFields(modelType);
    this.listFields = listFields ?? _defaultFields(modelType);
  }

  factory ModelUiConfig.fromJson(Map<String, dynamic> json) => ModelUiConfig(
        json['modelName'] as String,
        listFields: (json['listFields'] as List)
            .map((j) => DisplayField.fromJson(j))
            .toList(),
        viewFields: (json['viewFields'] as List)
            .map((j) => DisplayField.fromJson(j))
            .toList(),
      );

  Map<String, dynamic> toJson() => _$ModelUiConfigToJson(this);

  ModelSchema get schema => ModelProvider.instance.modelSchemas
      .firstWhere((e) => e.name == modelName);

  ModelType get modelType =>
      ModelProvider.instance.getModelTypeByModelName(modelName);

  ModelField modelField(String name) =>
      schema.fields!.values.firstWhere((f) => f.name == name);

  List<String> enumValuesForField(String fieldName) =>
      viewFields.firstWhere((e) => e.name == fieldName).values?.toList() ?? [];

  List<String> get listFieldNames =>
      listFields.map((f) => f.displayName).toList();

  List<String> get listFieldTitleNames =>
      listFieldNames.map((f) => f.toCapitalCase()).toList();

  // List<ModelField> get viewModelFields =>
  //     viewFields.map((f) => f.modelField).toList();

  List<String> get viewFieldNames => viewFields.map((f) => f.name).toList();

  List<String> get viewFieldDisplayNames =>
      viewFields.map((f) => f.displayName).toList();

  List<String> get viewFieldTitleNames =>
      viewFieldDisplayNames.map((f) => f.toCapitalCase()).toList();

  List<String> listFieldValues(Model model) =>
      listFields.map((f) => model.toMap()[f.name].toString()).toList();

  List<ModelField> get viewModelFields => schema.fields!.values
      .where((v) => viewFieldNames.contains(v.name))
      .toList();

  List<String> enumValues(String fieldName) =>
      viewFields.firstWhere((f) => f.name == fieldName).values ?? [];
}

@JsonSerializable()
class DisplayField {
  final String name;
  final String? altName;
  final bool readOnly;
  final String? linkedTo;
  final List<String>? values;

  DisplayField(this.name,
      {this.altName, this.readOnly = false, this.values, this.linkedTo});

  factory DisplayField.fromJson(Map<String, dynamic> json) =>
      _$DisplayFieldFromJson(json);

  Map<String, dynamic> toJson() => _$DisplayFieldToJson(this);

  String get displayName => altName ?? name;
}
