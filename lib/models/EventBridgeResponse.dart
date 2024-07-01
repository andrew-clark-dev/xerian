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


/** This is an auto generated class representing the EventBridgeResponse type in your schema. */
class EventBridgeResponse {
  final List<EventBridgeEntry>? _entries;
  final int? _failedEntryCount;

  List<EventBridgeEntry>? get entries {
    return _entries;
  }
  
  int? get failedEntryCount {
    return _failedEntryCount;
  }
  
  const EventBridgeResponse._internal({entries, failedEntryCount}): _entries = entries, _failedEntryCount = failedEntryCount;
  
  factory EventBridgeResponse({List<EventBridgeEntry>? entries, int? failedEntryCount}) {
    return EventBridgeResponse._internal(
      entries: entries != null ? List<EventBridgeEntry>.unmodifiable(entries) : entries,
      failedEntryCount: failedEntryCount);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventBridgeResponse &&
      DeepCollectionEquality().equals(_entries, other._entries) &&
      _failedEntryCount == other._failedEntryCount;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("EventBridgeResponse {");
    buffer.write("entries=" + (_entries != null ? _entries!.toString() : "null") + ", ");
    buffer.write("failedEntryCount=" + (_failedEntryCount != null ? _failedEntryCount!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  EventBridgeResponse copyWith({List<EventBridgeEntry>? entries, int? failedEntryCount}) {
    return EventBridgeResponse._internal(
      entries: entries ?? this.entries,
      failedEntryCount: failedEntryCount ?? this.failedEntryCount);
  }
  
  EventBridgeResponse copyWithModelFieldValues({
    ModelFieldValue<List<EventBridgeEntry>?>? entries,
    ModelFieldValue<int?>? failedEntryCount
  }) {
    return EventBridgeResponse._internal(
      entries: entries == null ? this.entries : entries.value,
      failedEntryCount: failedEntryCount == null ? this.failedEntryCount : failedEntryCount.value
    );
  }
  
  EventBridgeResponse.fromJson(Map<String, dynamic> json)  
    : _entries = json['entries'] is List
        ? (json['entries'] as List)
          .where((e) => e != null)
          .map((e) => EventBridgeEntry.fromJson(new Map<String, dynamic>.from(e['serializedData'] ?? e)))
          .toList()
        : null,
      _failedEntryCount = (json['failedEntryCount'] as num?)?.toInt();
  
  Map<String, dynamic> toJson() => {
    'entries': _entries?.map((EventBridgeEntry? e) => e?.toJson()).toList(), 'failedEntryCount': _failedEntryCount
  };
  
  Map<String, Object?> toMap() => {
    'entries': _entries,
    'failedEntryCount': _failedEntryCount
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "EventBridgeResponse";
    modelSchemaDefinition.pluralName = "EventBridgeResponses";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'entries',
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'EventBridgeEntry')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'failedEntryCount',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
  });
}