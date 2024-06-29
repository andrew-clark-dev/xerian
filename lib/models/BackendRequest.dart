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


/** This is an auto generated class representing the BackendRequest type in your schema. */
class BackendRequest extends amplify_core.Model {
  static const classType = const _BackendRequestModelType();
  final String id;
  final BackendRequestRequestType? _requestType;
  final String? _modelType;
  final String? _payload;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  BackendRequestModelIdentifier get modelIdentifier {
      return BackendRequestModelIdentifier(
        id: id
      );
  }
  
  BackendRequestRequestType? get requestType {
    return _requestType;
  }
  
  String get modelType {
    try {
      return _modelType!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get payload {
    try {
      return _payload!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const BackendRequest._internal({required this.id, requestType, required modelType, required payload, createdAt, updatedAt}): _requestType = requestType, _modelType = modelType, _payload = payload, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory BackendRequest({String? id, BackendRequestRequestType? requestType, required String modelType, required String payload}) {
    return BackendRequest._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      requestType: requestType,
      modelType: modelType,
      payload: payload);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackendRequest &&
      id == other.id &&
      _requestType == other._requestType &&
      _modelType == other._modelType &&
      _payload == other._payload;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("BackendRequest {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("requestType=" + (_requestType != null ? amplify_core.enumToString(_requestType)! : "null") + ", ");
    buffer.write("modelType=" + "$_modelType" + ", ");
    buffer.write("payload=" + "$_payload" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  BackendRequest copyWith({BackendRequestRequestType? requestType, String? modelType, String? payload}) {
    return BackendRequest._internal(
      id: id,
      requestType: requestType ?? this.requestType,
      modelType: modelType ?? this.modelType,
      payload: payload ?? this.payload);
  }
  
  BackendRequest copyWithModelFieldValues({
    ModelFieldValue<BackendRequestRequestType?>? requestType,
    ModelFieldValue<String>? modelType,
    ModelFieldValue<String>? payload
  }) {
    return BackendRequest._internal(
      id: id,
      requestType: requestType == null ? this.requestType : requestType.value,
      modelType: modelType == null ? this.modelType : modelType.value,
      payload: payload == null ? this.payload : payload.value
    );
  }
  
  BackendRequest.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _requestType = amplify_core.enumFromString<BackendRequestRequestType>(json['requestType'], BackendRequestRequestType.values),
      _modelType = json['modelType'],
      _payload = json['payload'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'requestType': amplify_core.enumToString(_requestType), 'modelType': _modelType, 'payload': _payload, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'requestType': _requestType,
    'modelType': _modelType,
    'payload': _payload,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<BackendRequestModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<BackendRequestModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final REQUESTTYPE = amplify_core.QueryField(fieldName: "requestType");
  static final MODELTYPE = amplify_core.QueryField(fieldName: "modelType");
  static final PAYLOAD = amplify_core.QueryField(fieldName: "payload");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "BackendRequest";
    modelSchemaDefinition.pluralName = "BackendRequests";
    
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
      key: BackendRequest.REQUESTTYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BackendRequest.MODELTYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BackendRequest.PAYLOAD,
      isRequired: true,
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

class _BackendRequestModelType extends amplify_core.ModelType<BackendRequest> {
  const _BackendRequestModelType();
  
  @override
  BackendRequest fromJson(Map<String, dynamic> jsonData) {
    return BackendRequest.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'BackendRequest';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [BackendRequest] in your schema.
 */
class BackendRequestModelIdentifier implements amplify_core.ModelIdentifier<BackendRequest> {
  final String id;

  /** Create an instance of BackendRequestModelIdentifier using [id] the primary key. */
  const BackendRequestModelIdentifier({
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
  String toString() => 'BackendRequestModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is BackendRequestModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}