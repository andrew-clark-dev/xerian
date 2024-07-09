// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_ui_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: unused_element
ModelUiConfig _$ModelUiConfigFromJson(Map<String, dynamic> json) =>
    ModelUiConfig(
      json['modelName'] as String,
      listFields: json['listFields'],
      viewFields: json['viewFields'],
    );

Map<String, dynamic> _$ModelUiConfigToJson(ModelUiConfig instance) =>
    <String, dynamic>{
      'modelName': instance.modelName,
      'listFields': instance.listFields.map((e) => e.toJson()).toList(),
      'viewFields': instance.viewFields.map((e) => e.toJson()).toList(),
    };

DisplayField _$DisplayFieldFromJson(Map<String, dynamic> json) => DisplayField(
      json['name'] as String,
      altName: json['altName'] as String?,
      readOnly: json['readOnly'] as bool? ?? false,
      values:
          (json['values'] as List<dynamic>?)?.map((e) => e as String).toList(),
      linkedTo: json['linkedTo'] as String?,
    );

Map<String, dynamic> _$DisplayFieldToJson(DisplayField instance) =>
    <String, dynamic>{
      'name': instance.name,
      'altName': instance.altName,
      'readOnly': instance.readOnly,
      'linkedTo': instance.linkedTo,
      'values': instance.values,
    };
