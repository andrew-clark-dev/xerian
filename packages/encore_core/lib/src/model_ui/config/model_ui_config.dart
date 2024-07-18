import 'dart:convert';
import 'package:encore_core/src/model_ui/config/model_extensions.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';

import 'package:amplify_core/amplify_core.dart';
import 'package:change_case/change_case.dart';

import 'package:json_annotation/json_annotation.dart';

part 'model_ui_config.g.dart';

ModelProviderInterface? modelProvider;

@JsonSerializable(explicitToJson: true)
class ModelUiConfiguration {
  static ModelUiConfiguration? _modelUiConfiguration;

  static void configure(String configuration, ModelProviderInterface provider) {
    modelProvider = provider;
    _modelUiConfiguration = ModelUiConfiguration._internal(configuration);
    safePrint("Configuration used");
    safePrint(_modelUiConfiguration!.toJson().encodedJsonString);
  }

  static get configurations => _modelUiConfiguration?.modelConfigurations;

  static ModelUiConfig get(ModelType modelType) =>
      configurations[modelType.modelName()];

  Map<String, ModelUiConfig> modelConfigurations = {};

  // Create a new config (for testing only)
  ModelUiConfiguration(this.modelConfigurations);

  ModelUiConfiguration._internal(String configuration) {
    if (_modelUiConfiguration != null) {
      throw 'Model Ui Configuration error - already configured';
    }

    Map<String, dynamic> modelUiConfigJson = {};

    if (configuration.isNotEmpty) {
      modelUiConfigJson = jsonDecode(configuration);
    }

    // Default configs
    for (var modelSchema in modelProvider!.modelSchemas) {
      final name = modelSchema.name;
      if (modelUiConfigJson.keys.contains(name)) {
        modelConfigurations[name] =
            ModelUiConfig.fromJson(modelUiConfigJson[name]);
      } else {
        modelConfigurations[name] = ModelUiConfig(name);
      }
    }
  }

  Map<String, dynamic> toJson() => _$ModelUiConfigurationToJson(this);

  factory ModelUiConfiguration.fromJson(Map<String, dynamic> json) =>
      _$ModelUiConfigurationFromJson(json);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ModelUiConfig {
  /// The list of feild never to show in the basic ui components.
  /// Id is given by amplify, Model UI never displays it
  /// Model UI also support directly meta data on any model Model UI never displays it.
  static final List<String> hiddenFields = ['id', 'metaData'];

  /// These fileds are never input by the user. So are ALWAY readonly when displyed.
  static final List<String> autosetFields = ['id', 'createdAt', 'updatedAt'];

  // return the default field config, used when no config found in json file
  List<DisplayField> _defaultFields(ModelType modelType) {
    return modelType.schema.fields!.values
        .where((v) => !hiddenFields.contains(v.name))
        .map((f) =>
            DisplayField(f.name, readOnly: autosetFields.contains(f.name)))
        .toList();
  }

  final String modelName;
  late final List<DisplayField> listFields;
  late final List<DisplayField> viewFields;

  ///  The config object
  ModelUiConfig(this.modelName, {listFields, viewFields}) {
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

  ModelSchema get schema =>
      modelProvider!.modelSchemas.firstWhere((e) => e.name == modelName);

  ModelType get modelType => modelProvider!.getModelTypeByModelName(modelName);

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

  String viewFieldTitleName(String name) =>
      viewFields.firstWhere((f) => f.name == name).displayName.toCapitalCase();

  List<String> listFieldValues(Model model) =>
      listFields.map((f) => model.toMap()[f.name].toString()).toList();

  List<ModelField> get viewModelFields => schema.fields!.values
      .where((v) => viewFieldNames.contains(v.name))
      .toList();

  List<ModelField> get viewModelSettableFields => schema.fields!.values
      .where((v) => viewFieldNames.contains(v.name))
      .toList();

  List<String> enumValues(String fieldName) =>
      viewFields.firstWhere((f) => f.name == fieldName).values ?? [];
}

@JsonSerializable(includeIfNull: false)
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
