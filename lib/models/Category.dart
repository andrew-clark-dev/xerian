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


/** This is an auto generated class representing the Category type in your schema. */
class Category extends amplify_core.Model {
  static const classType = const _CategoryModelType();
  final String id;
  final List<Item>? _item;
  final String? _value;
  final List<String>? _alternatives;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  CategoryModelIdentifier get modelIdentifier {
      return CategoryModelIdentifier(
        id: id
      );
  }
  
  List<Item>? get item {
    return _item;
  }
  
  String get value {
    try {
      return _value!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String>? get alternatives {
    return _alternatives;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Category._internal({required this.id, item, required value, alternatives, createdAt, updatedAt}): _item = item, _value = value, _alternatives = alternatives, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Category({String? id, List<Item>? item, required String value, List<String>? alternatives}) {
    return Category._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      item: item != null ? List<Item>.unmodifiable(item) : item,
      value: value,
      alternatives: alternatives != null ? List<String>.unmodifiable(alternatives) : alternatives);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Category &&
      id == other.id &&
      DeepCollectionEquality().equals(_item, other._item) &&
      _value == other._value &&
      DeepCollectionEquality().equals(_alternatives, other._alternatives);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Category {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("value=" + "$_value" + ", ");
    buffer.write("alternatives=" + (_alternatives != null ? _alternatives.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Category copyWith({List<Item>? item, String? value, List<String>? alternatives}) {
    return Category._internal(
      id: id,
      item: item ?? this.item,
      value: value ?? this.value,
      alternatives: alternatives ?? this.alternatives);
  }
  
  Category copyWithModelFieldValues({
    ModelFieldValue<List<Item>?>? item,
    ModelFieldValue<String>? value,
    ModelFieldValue<List<String>?>? alternatives
  }) {
    return Category._internal(
      id: id,
      item: item == null ? this.item : item.value,
      value: value == null ? this.value : value.value,
      alternatives: alternatives == null ? this.alternatives : alternatives.value
    );
  }
  
  Category.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _item = json['item']  is Map
        ? (json['item']['items'] is List
          ? (json['item']['items'] as List)
              .where((e) => e != null)
              .map((e) => Item.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['item'] is List
          ? (json['item'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Item.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _value = json['value'],
      _alternatives = json['alternatives']?.cast<String>(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'item': _item?.map((Item? e) => e?.toJson()).toList(), 'value': _value, 'alternatives': _alternatives, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'item': _item,
    'value': _value,
    'alternatives': _alternatives,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<CategoryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<CategoryModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ITEM = amplify_core.QueryField(
    fieldName: "item",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Item'));
  static final VALUE = amplify_core.QueryField(fieldName: "value");
  static final ALTERNATIVES = amplify_core.QueryField(fieldName: "alternatives");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Category";
    modelSchemaDefinition.pluralName = "Categories";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Category.ITEM,
      isRequired: false,
      ofModelName: 'Item',
      associatedKey: Item.CATEGORY
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Category.VALUE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Category.ALTERNATIVES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
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

class _CategoryModelType extends amplify_core.ModelType<Category> {
  const _CategoryModelType();
  
  @override
  Category fromJson(Map<String, dynamic> jsonData) {
    return Category.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Category';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Category] in your schema.
 */
class CategoryModelIdentifier implements amplify_core.ModelIdentifier<Category> {
  final String id;

  /** Create an instance of CategoryModelIdentifier using [id] the primary key. */
  const CategoryModelIdentifier({
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
  String toString() => 'CategoryModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is CategoryModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}