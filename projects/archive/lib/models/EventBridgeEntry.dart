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


/** This is an auto generated class representing the EventBridgeEntry type in your schema. */
class EventBridgeEntry {
  final String? _errorCode;
  final String? _errorMessage;
  final String? _eventId;

  String? get errorCode {
    return _errorCode;
  }
  
  String? get errorMessage {
    return _errorMessage;
  }
  
  String? get eventId {
    return _eventId;
  }
  
  const EventBridgeEntry._internal({errorCode, errorMessage, eventId}): _errorCode = errorCode, _errorMessage = errorMessage, _eventId = eventId;
  
  factory EventBridgeEntry({String? errorCode, String? errorMessage, String? eventId}) {
    return EventBridgeEntry._internal(
      errorCode: errorCode,
      errorMessage: errorMessage,
      eventId: eventId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventBridgeEntry &&
      _errorCode == other._errorCode &&
      _errorMessage == other._errorMessage &&
      _eventId == other._eventId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("EventBridgeEntry {");
    buffer.write("errorCode=" + "$_errorCode" + ", ");
    buffer.write("errorMessage=" + "$_errorMessage" + ", ");
    buffer.write("eventId=" + "$_eventId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  EventBridgeEntry copyWith({String? errorCode, String? errorMessage, String? eventId}) {
    return EventBridgeEntry._internal(
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
      eventId: eventId ?? this.eventId);
  }
  
  EventBridgeEntry copyWithModelFieldValues({
    ModelFieldValue<String?>? errorCode,
    ModelFieldValue<String?>? errorMessage,
    ModelFieldValue<String?>? eventId
  }) {
    return EventBridgeEntry._internal(
      errorCode: errorCode == null ? this.errorCode : errorCode.value,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage.value,
      eventId: eventId == null ? this.eventId : eventId.value
    );
  }
  
  EventBridgeEntry.fromJson(Map<String, dynamic> json)  
    : _errorCode = json['errorCode'],
      _errorMessage = json['errorMessage'],
      _eventId = json['eventId'];
  
  Map<String, dynamic> toJson() => {
    'errorCode': _errorCode, 'errorMessage': _errorMessage, 'eventId': _eventId
  };
  
  Map<String, Object?> toMap() => {
    'errorCode': _errorCode,
    'errorMessage': _errorMessage,
    'eventId': _eventId
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "EventBridgeEntry";
    modelSchemaDefinition.pluralName = "EventBridgeEntries";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'errorCode',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'errorMessage',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'eventId',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}