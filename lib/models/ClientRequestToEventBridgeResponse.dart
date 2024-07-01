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


/** This is an auto generated class representing the ClientRequestToEventBridgeResponse type in your schema. */
class ClientRequestToEventBridgeResponse {
  final int? _statusCode;
  final String? _headers;
  final String? _body;

  int? get statusCode {
    return _statusCode;
  }
  
  String? get headers {
    return _headers;
  }
  
  String? get body {
    return _body;
  }
  
  const ClientRequestToEventBridgeResponse._internal({statusCode, headers, body}): _statusCode = statusCode, _headers = headers, _body = body;
  
  factory ClientRequestToEventBridgeResponse({int? statusCode, String? headers, String? body}) {
    return ClientRequestToEventBridgeResponse._internal(
      statusCode: statusCode,
      headers: headers,
      body: body);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientRequestToEventBridgeResponse &&
      _statusCode == other._statusCode &&
      _headers == other._headers &&
      _body == other._body;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ClientRequestToEventBridgeResponse {");
    buffer.write("statusCode=" + (_statusCode != null ? _statusCode!.toString() : "null") + ", ");
    buffer.write("headers=" + "$_headers" + ", ");
    buffer.write("body=" + "$_body");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ClientRequestToEventBridgeResponse copyWith({int? statusCode, String? headers, String? body}) {
    return ClientRequestToEventBridgeResponse._internal(
      statusCode: statusCode ?? this.statusCode,
      headers: headers ?? this.headers,
      body: body ?? this.body);
  }
  
  ClientRequestToEventBridgeResponse copyWithModelFieldValues({
    ModelFieldValue<int?>? statusCode,
    ModelFieldValue<String?>? headers,
    ModelFieldValue<String?>? body
  }) {
    return ClientRequestToEventBridgeResponse._internal(
      statusCode: statusCode == null ? this.statusCode : statusCode.value,
      headers: headers == null ? this.headers : headers.value,
      body: body == null ? this.body : body.value
    );
  }
  
  ClientRequestToEventBridgeResponse.fromJson(Map<String, dynamic> json)  
    : _statusCode = (json['statusCode'] as num?)?.toInt(),
      _headers = json['headers'],
      _body = json['body'];
  
  Map<String, dynamic> toJson() => {
    'statusCode': _statusCode, 'headers': _headers, 'body': _body
  };
  
  Map<String, Object?> toMap() => {
    'statusCode': _statusCode,
    'headers': _headers,
    'body': _body
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ClientRequestToEventBridgeResponse";
    modelSchemaDefinition.pluralName = "ClientRequestToEventBridgeResponses";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'statusCode',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'headers',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'body',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}