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


/** This is an auto generated class representing the Journal type in your schema. */
class Journal extends amplify_core.Model {
  static const classType = const _JournalModelType();
  final String id;
  final String? _modelId;
  final amplify_core.TemporalDateTime? _timestamp;
  final String? _action;
  final String? _before;
  final String? _after;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  JournalModelIdentifier get modelIdentifier {
      return JournalModelIdentifier(
        id: id
      );
  }
  
  String get modelId {
    try {
      return _modelId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get timestamp {
    try {
      return _timestamp!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get action {
    return _action;
  }
  
  String? get before {
    return _before;
  }
  
  String? get after {
    return _after;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Journal._internal({required this.id, required modelId, required timestamp, action, before, after, createdAt, updatedAt}): _modelId = modelId, _timestamp = timestamp, _action = action, _before = before, _after = after, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Journal({String? id, required String modelId, required amplify_core.TemporalDateTime timestamp, String? action, String? before, String? after}) {
    return Journal._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      modelId: modelId,
      timestamp: timestamp,
      action: action,
      before: before,
      after: after);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Journal &&
      id == other.id &&
      _modelId == other._modelId &&
      _timestamp == other._timestamp &&
      _action == other._action &&
      _before == other._before &&
      _after == other._after;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Journal {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("modelId=" + "$_modelId" + ", ");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp!.format() : "null") + ", ");
    buffer.write("action=" + "$_action" + ", ");
    buffer.write("before=" + "$_before" + ", ");
    buffer.write("after=" + "$_after" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Journal copyWith({String? modelId, amplify_core.TemporalDateTime? timestamp, String? action, String? before, String? after}) {
    return Journal._internal(
      id: id,
      modelId: modelId ?? this.modelId,
      timestamp: timestamp ?? this.timestamp,
      action: action ?? this.action,
      before: before ?? this.before,
      after: after ?? this.after);
  }
  
  Journal copyWithModelFieldValues({
    ModelFieldValue<String>? modelId,
    ModelFieldValue<amplify_core.TemporalDateTime>? timestamp,
    ModelFieldValue<String?>? action,
    ModelFieldValue<String?>? before,
    ModelFieldValue<String?>? after
  }) {
    return Journal._internal(
      id: id,
      modelId: modelId == null ? this.modelId : modelId.value,
      timestamp: timestamp == null ? this.timestamp : timestamp.value,
      action: action == null ? this.action : action.value,
      before: before == null ? this.before : before.value,
      after: after == null ? this.after : after.value
    );
  }
  
  Journal.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _modelId = json['modelId'],
      _timestamp = json['timestamp'] != null ? amplify_core.TemporalDateTime.fromString(json['timestamp']) : null,
      _action = json['action'],
      _before = json['before'],
      _after = json['after'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'modelId': _modelId, 'timestamp': _timestamp?.format(), 'action': _action, 'before': _before, 'after': _after, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'modelId': _modelId,
    'timestamp': _timestamp,
    'action': _action,
    'before': _before,
    'after': _after,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<JournalModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<JournalModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final MODELID = amplify_core.QueryField(fieldName: "modelId");
  static final TIMESTAMP = amplify_core.QueryField(fieldName: "timestamp");
  static final ACTION = amplify_core.QueryField(fieldName: "action");
  static final BEFORE = amplify_core.QueryField(fieldName: "before");
  static final AFTER = amplify_core.QueryField(fieldName: "after");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Journal";
    modelSchemaDefinition.pluralName = "Journals";
    
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
      key: Journal.MODELID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Journal.TIMESTAMP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Journal.ACTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Journal.BEFORE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Journal.AFTER,
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

class _JournalModelType extends amplify_core.ModelType<Journal> {
  const _JournalModelType();
  
  @override
  Journal fromJson(Map<String, dynamic> jsonData) {
    return Journal.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Journal';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Journal] in your schema.
 */
class JournalModelIdentifier implements amplify_core.ModelIdentifier<Journal> {
  final String id;

  /** Create an instance of JournalModelIdentifier using [id] the primary key. */
  const JournalModelIdentifier({
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
  String toString() => 'JournalModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is JournalModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}