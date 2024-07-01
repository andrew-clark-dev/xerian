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


/** This is an auto generated class representing the ServerEvent type in your schema. */
class ServerEvent {
  final String? _eventId;
  final ServerEventType? _eventType;
  final String? _modelType;
  final String? _payload;

  String get eventId {
    try {
      return _eventId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  ServerEventType get eventType {
    try {
      return _eventType!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
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
  
  const ServerEvent._internal({required eventId, required eventType, required modelType, required payload}): _eventId = eventId, _eventType = eventType, _modelType = modelType, _payload = payload;
  
  factory ServerEvent({required String eventId, required ServerEventType eventType, required String modelType, required String payload}) {
    return ServerEvent._internal(
      eventId: eventId,
      eventType: eventType,
      modelType: modelType,
      payload: payload);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ServerEvent &&
      _eventId == other._eventId &&
      _eventType == other._eventType &&
      _modelType == other._modelType &&
      _payload == other._payload;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ServerEvent {");
    buffer.write("eventId=" + "$_eventId" + ", ");
    buffer.write("eventType=" + (_eventType != null ? amplify_core.enumToString(_eventType)! : "null") + ", ");
    buffer.write("modelType=" + "$_modelType" + ", ");
    buffer.write("payload=" + "$_payload");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ServerEvent copyWith({String? eventId, ServerEventType? eventType, String? modelType, String? payload}) {
    return ServerEvent._internal(
      eventId: eventId ?? this.eventId,
      eventType: eventType ?? this.eventType,
      modelType: modelType ?? this.modelType,
      payload: payload ?? this.payload);
  }
  
  ServerEvent copyWithModelFieldValues({
    ModelFieldValue<String>? eventId,
    ModelFieldValue<ServerEventType>? eventType,
    ModelFieldValue<String>? modelType,
    ModelFieldValue<String>? payload
  }) {
    return ServerEvent._internal(
      eventId: eventId == null ? this.eventId : eventId.value,
      eventType: eventType == null ? this.eventType : eventType.value,
      modelType: modelType == null ? this.modelType : modelType.value,
      payload: payload == null ? this.payload : payload.value
    );
  }
  
  ServerEvent.fromJson(Map<String, dynamic> json)  
    : _eventId = json['eventId'],
      _eventType = amplify_core.enumFromString<ServerEventType>(json['eventType'], ServerEventType.values),
      _modelType = json['modelType'],
      _payload = json['payload'];
  
  Map<String, dynamic> toJson() => {
    'eventId': _eventId, 'eventType': amplify_core.enumToString(_eventType), 'modelType': _modelType, 'payload': _payload
  };
  
  Map<String, Object?> toMap() => {
    'eventId': _eventId,
    'eventType': _eventType,
    'modelType': _modelType,
    'payload': _payload
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ServerEvent";
    modelSchemaDefinition.pluralName = "ServerEvents";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'eventId',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'eventType',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'modelType',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'payload',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}