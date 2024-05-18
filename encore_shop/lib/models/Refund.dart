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


/** This is an auto generated class representing the Refund type in your schema. */
class Refund extends amplify_core.Model {
  static const classType = const _RefundModelType();
  final String id;
  final int? _number;
  final RefundStatus? _status;
  final amplify_core.TemporalDateTime? _finalized;
  final double? _total;
  final double? _subtotal;
  final RefundPaymentType? _paymentType;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  RefundModelIdentifier get modelIdentifier {
      return RefundModelIdentifier(
        id: id
      );
  }
  
  int? get number {
    return _number;
  }
  
  RefundStatus? get status {
    return _status;
  }
  
  amplify_core.TemporalDateTime? get finalized {
    return _finalized;
  }
  
  double? get total {
    return _total;
  }
  
  double? get subtotal {
    return _subtotal;
  }
  
  RefundPaymentType? get paymentType {
    return _paymentType;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Refund._internal({required this.id, number, status, finalized, total, subtotal, paymentType, createdAt, updatedAt}): _number = number, _status = status, _finalized = finalized, _total = total, _subtotal = subtotal, _paymentType = paymentType, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Refund({String? id, int? number, RefundStatus? status, amplify_core.TemporalDateTime? finalized, double? total, double? subtotal, RefundPaymentType? paymentType}) {
    return Refund._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      number: number,
      status: status,
      finalized: finalized,
      total: total,
      subtotal: subtotal,
      paymentType: paymentType);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Refund &&
      id == other.id &&
      _number == other._number &&
      _status == other._status &&
      _finalized == other._finalized &&
      _total == other._total &&
      _subtotal == other._subtotal &&
      _paymentType == other._paymentType;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Refund {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("number=" + (_number != null ? _number!.toString() : "null") + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("finalized=" + (_finalized != null ? _finalized!.format() : "null") + ", ");
    buffer.write("total=" + (_total != null ? _total!.toString() : "null") + ", ");
    buffer.write("subtotal=" + (_subtotal != null ? _subtotal!.toString() : "null") + ", ");
    buffer.write("paymentType=" + (_paymentType != null ? amplify_core.enumToString(_paymentType)! : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Refund copyWith({int? number, RefundStatus? status, amplify_core.TemporalDateTime? finalized, double? total, double? subtotal, RefundPaymentType? paymentType}) {
    return Refund._internal(
      id: id,
      number: number ?? this.number,
      status: status ?? this.status,
      finalized: finalized ?? this.finalized,
      total: total ?? this.total,
      subtotal: subtotal ?? this.subtotal,
      paymentType: paymentType ?? this.paymentType);
  }
  
  Refund copyWithModelFieldValues({
    ModelFieldValue<int?>? number,
    ModelFieldValue<RefundStatus?>? status,
    ModelFieldValue<amplify_core.TemporalDateTime?>? finalized,
    ModelFieldValue<double?>? total,
    ModelFieldValue<double?>? subtotal,
    ModelFieldValue<RefundPaymentType?>? paymentType
  }) {
    return Refund._internal(
      id: id,
      number: number == null ? this.number : number.value,
      status: status == null ? this.status : status.value,
      finalized: finalized == null ? this.finalized : finalized.value,
      total: total == null ? this.total : total.value,
      subtotal: subtotal == null ? this.subtotal : subtotal.value,
      paymentType: paymentType == null ? this.paymentType : paymentType.value
    );
  }
  
  Refund.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _number = (json['number'] as num?)?.toInt(),
      _status = amplify_core.enumFromString<RefundStatus>(json['status'], RefundStatus.values),
      _finalized = json['finalized'] != null ? amplify_core.TemporalDateTime.fromString(json['finalized']) : null,
      _total = (json['total'] as num?)?.toDouble(),
      _subtotal = (json['subtotal'] as num?)?.toDouble(),
      _paymentType = amplify_core.enumFromString<RefundPaymentType>(json['paymentType'], RefundPaymentType.values),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'number': _number, 'status': amplify_core.enumToString(_status), 'finalized': _finalized?.format(), 'total': _total, 'subtotal': _subtotal, 'paymentType': amplify_core.enumToString(_paymentType), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'number': _number,
    'status': _status,
    'finalized': _finalized,
    'total': _total,
    'subtotal': _subtotal,
    'paymentType': _paymentType,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<RefundModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<RefundModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NUMBER = amplify_core.QueryField(fieldName: "number");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final FINALIZED = amplify_core.QueryField(fieldName: "finalized");
  static final TOTAL = amplify_core.QueryField(fieldName: "total");
  static final SUBTOTAL = amplify_core.QueryField(fieldName: "subtotal");
  static final PAYMENTTYPE = amplify_core.QueryField(fieldName: "paymentType");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Refund";
    modelSchemaDefinition.pluralName = "Refunds";
    
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
      key: Refund.NUMBER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Refund.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Refund.FINALIZED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Refund.TOTAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Refund.SUBTOTAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Refund.PAYMENTTYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
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

class _RefundModelType extends amplify_core.ModelType<Refund> {
  const _RefundModelType();
  
  @override
  Refund fromJson(Map<String, dynamic> jsonData) {
    return Refund.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Refund';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Refund] in your schema.
 */
class RefundModelIdentifier implements amplify_core.ModelIdentifier<Refund> {
  final String id;

  /** Create an instance of RefundModelIdentifier using [id] the primary key. */
  const RefundModelIdentifier({
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
  String toString() => 'RefundModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is RefundModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}