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


/** This is an auto generated class representing the SyncInfo type in your schema. */
class SyncInfo extends amplify_core.Model {
  static const classType = const _SyncInfoModelType();
  final String id;
  final String? _modelType;
  final String? _user;
  final amplify_core.TemporalDateTime? _timestamp;
  final String? _metadata;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SyncInfoModelIdentifier get modelIdentifier {
      return SyncInfoModelIdentifier(
        id: id
      );
  }
  
  String? get modelType {
    return _modelType;
  }
  
  String? get user {
    return _user;
  }
  
  amplify_core.TemporalDateTime? get timestamp {
    return _timestamp;
  }
  
  String? get metadata {
    return _metadata;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const SyncInfo._internal({required this.id, modelType, user, timestamp, metadata, createdAt, updatedAt}): _modelType = modelType, _user = user, _timestamp = timestamp, _metadata = metadata, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SyncInfo({String? id, String? modelType, String? user, amplify_core.TemporalDateTime? timestamp, String? metadata}) {
    return SyncInfo._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      modelType: modelType,
      user: user,
      timestamp: timestamp,
      metadata: metadata);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncInfo &&
      id == other.id &&
      _modelType == other._modelType &&
      _user == other._user &&
      _timestamp == other._timestamp &&
      _metadata == other._metadata;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SyncInfo {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("modelType=" + "$_modelType" + ", ");
    buffer.write("user=" + "$_user" + ", ");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp.format() : "null") + ", ");
    buffer.write("metadata=" + "$_metadata" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SyncInfo copyWith({String? modelType, String? user, amplify_core.TemporalDateTime? timestamp, String? metadata}) {
    return SyncInfo._internal(
      id: id,
      modelType: modelType ?? this.modelType,
      user: user ?? this.user,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata);
  }
  
  SyncInfo copyWithModelFieldValues({
    ModelFieldValue<String?>? modelType,
    ModelFieldValue<String?>? user,
    ModelFieldValue<amplify_core.TemporalDateTime?>? timestamp,
    ModelFieldValue<String?>? metadata
  }) {
    return SyncInfo._internal(
      id: id,
      modelType: modelType == null ? this.modelType : modelType.value,
      user: user == null ? this.user : user.value,
      timestamp: timestamp == null ? this.timestamp : timestamp.value,
      metadata: metadata == null ? this.metadata : metadata.value
    );
  }
  
  SyncInfo.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _modelType = json['modelType'],
      _user = json['user'],
      _timestamp = json['timestamp'] != null ? amplify_core.TemporalDateTime.fromString(json['timestamp']) : null,
      _metadata = json['metadata'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'modelType': _modelType, 'user': _user, 'timestamp': _timestamp?.format(), 'metadata': _metadata, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'modelType': _modelType,
    'user': _user,
    'timestamp': _timestamp,
    'metadata': _metadata,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SyncInfoModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SyncInfoModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final MODELTYPE = amplify_core.QueryField(fieldName: "modelType");
  static final USER = amplify_core.QueryField(fieldName: "user");
  static final TIMESTAMP = amplify_core.QueryField(fieldName: "timestamp");
  static final METADATA = amplify_core.QueryField(fieldName: "metadata");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SyncInfo";
    modelSchemaDefinition.pluralName = "SyncInfos";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SyncInfo.MODELTYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SyncInfo.USER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SyncInfo.TIMESTAMP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SyncInfo.METADATA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _SyncInfoModelType extends amplify_core.ModelType<SyncInfo> {
  const _SyncInfoModelType();
  
  @override
  SyncInfo fromJson(Map<String, dynamic> jsonData) {
    return SyncInfo.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SyncInfo';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SyncInfo] in your schema.
 */
class SyncInfoModelIdentifier implements amplify_core.ModelIdentifier<SyncInfo> {
  final String id;

  /** Create an instance of SyncInfoModelIdentifier using [id] the primary key. */
  const SyncInfoModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'SyncInfoModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SyncInfoModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}