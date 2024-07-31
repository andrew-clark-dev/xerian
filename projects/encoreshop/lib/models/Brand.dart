/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Brand type in your schema. */
class Brand extends amplify_core.Model {
  static const classType = const _BrandModelType();
  final String? _name;
  final List<String>? _alt;
  final String? _metadata;
  final bool? _active;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => modelIdentifier.serializeAsString();
  
  BrandModelIdentifier get modelIdentifier {
    try {
      return BrandModelIdentifier(
        name: _name!
      );
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String>? get alt {
    return _alt;
  }
  
  String? get metadata {
    return _metadata;
  }
  
  bool? get active {
    return _active;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Brand._internal({required name, alt, metadata, active, createdAt, updatedAt}): _name = name, _alt = alt, _metadata = metadata, _active = active, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Brand({required String name, List<String>? alt, String? metadata, bool? active}) {
    return Brand._internal(
      name: name,
      alt: alt != null ? List<String>.unmodifiable(alt) : alt,
      metadata: metadata,
      active: active);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Brand &&
      _name == other._name &&
      DeepCollectionEquality().equals(_alt, other._alt) &&
      _metadata == other._metadata &&
      _active == other._active;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Brand {");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("alt=" + (_alt != null ? _alt.toString() : "null") + ", ");
    buffer.write("metadata=" + "$_metadata" + ", ");
    buffer.write("active=" + (_active != null ? _active.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Brand copyWith({List<String>? alt, String? metadata, bool? active}) {
    return Brand._internal(
      name: name,
      alt: alt ?? this.alt,
      metadata: metadata ?? this.metadata,
      active: active ?? this.active);
  }
  
  Brand copyWithModelFieldValues({
    ModelFieldValue<List<String>?>? alt,
    ModelFieldValue<String?>? metadata,
    ModelFieldValue<bool?>? active
  }) {
    return Brand._internal(
      name: name,
      alt: alt == null ? this.alt : alt.value,
      metadata: metadata == null ? this.metadata : metadata.value,
      active: active == null ? this.active : active.value
    );
  }
  
  Brand.fromJson(Map<String, dynamic> json)  
    : _name = json['name'],
      _alt = json['alt']?.cast<String>(),
      _metadata = json['metadata'],
      _active = json['active'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'name': _name, 'alt': _alt, 'metadata': _metadata, 'active': _active, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'name': _name,
    'alt': _alt,
    'metadata': _metadata,
    'active': _active,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<BrandModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<BrandModelIdentifier>();
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final ALT = amplify_core.QueryField(fieldName: "alt");
  static final METADATA = amplify_core.QueryField(fieldName: "metadata");
  static final ACTIVE = amplify_core.QueryField(fieldName: "active");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Brand";
    modelSchemaDefinition.pluralName = "Brands";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["name"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Brand.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Brand.ALT,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Brand.METADATA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Brand.ACTIVE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _BrandModelType extends amplify_core.ModelType<Brand> {
  const _BrandModelType();
  
  @override
  Brand fromJson(Map<String, dynamic> jsonData) {
    return Brand.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Brand';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Brand] in your schema.
 */
class BrandModelIdentifier implements amplify_core.ModelIdentifier<Brand> {
  final String name;

  /** Create an instance of BrandModelIdentifier using [name] the primary key. */
  const BrandModelIdentifier({
    required this.name});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'name': name
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'BrandModelIdentifier(name: $name)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is BrandModelIdentifier &&
      name == other.name;
  }
  
  @override
  int get hashCode =>
    name.hashCode;
}