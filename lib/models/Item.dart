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


/** This is an auto generated class representing the Item type in your schema. */
class Item extends amplify_core.Model {
  static const classType = const _ItemModelType();
  final String id;
  final int? _sku;
  final List<ItemCategory>? _categories;
  final String? _description;
  final String? _details;
  final List<String>? _images;
  final ItemQuality? _quality;
  final int? _split;
  final ItemStatus? _status;
  final String? _original;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ItemModelIdentifier get modelIdentifier {
      return ItemModelIdentifier(
        id: id
      );
  }
  
  int get sku {
    try {
      return _sku!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<ItemCategory>? get categories {
    return _categories;
  }
  
  String get description {
    try {
      return _description!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get details {
    return _details;
  }
  
  List<String>? get images {
    return _images;
  }
  
  ItemQuality? get quality {
    return _quality;
  }
  
  int? get split {
    return _split;
  }
  
  ItemStatus? get status {
    return _status;
  }
  
  String? get original {
    return _original;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Item._internal({required this.id, required sku, categories, required description, details, images, quality, split, status, original, createdAt, updatedAt}): _sku = sku, _categories = categories, _description = description, _details = details, _images = images, _quality = quality, _split = split, _status = status, _original = original, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Item({String? id, required int sku, List<ItemCategory>? categories, required String description, String? details, List<String>? images, ItemQuality? quality, int? split, ItemStatus? status, String? original}) {
    return Item._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      sku: sku,
      categories: categories != null ? List<ItemCategory>.unmodifiable(categories) : categories,
      description: description,
      details: details,
      images: images != null ? List<String>.unmodifiable(images) : images,
      quality: quality,
      split: split,
      status: status,
      original: original);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Item &&
      id == other.id &&
      _sku == other._sku &&
      DeepCollectionEquality().equals(_categories, other._categories) &&
      _description == other._description &&
      _details == other._details &&
      DeepCollectionEquality().equals(_images, other._images) &&
      _quality == other._quality &&
      _split == other._split &&
      _status == other._status &&
      _original == other._original;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Item {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sku=" + (_sku != null ? _sku.toString() : "null") + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("details=" + "$_details" + ", ");
    buffer.write("images=" + (_images != null ? _images.toString() : "null") + ", ");
    buffer.write("quality=" + (_quality != null ? amplify_core.enumToString(_quality)! : "null") + ", ");
    buffer.write("split=" + (_split != null ? _split.toString() : "null") + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("original=" + "$_original" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Item copyWith({int? sku, List<ItemCategory>? categories, String? description, String? details, List<String>? images, ItemQuality? quality, int? split, ItemStatus? status, String? original}) {
    return Item._internal(
      id: id,
      sku: sku ?? this.sku,
      categories: categories ?? this.categories,
      description: description ?? this.description,
      details: details ?? this.details,
      images: images ?? this.images,
      quality: quality ?? this.quality,
      split: split ?? this.split,
      status: status ?? this.status,
      original: original ?? this.original);
  }
  
  Item copyWithModelFieldValues({
    ModelFieldValue<int>? sku,
    ModelFieldValue<List<ItemCategory>?>? categories,
    ModelFieldValue<String>? description,
    ModelFieldValue<String?>? details,
    ModelFieldValue<List<String>?>? images,
    ModelFieldValue<ItemQuality?>? quality,
    ModelFieldValue<int?>? split,
    ModelFieldValue<ItemStatus?>? status,
    ModelFieldValue<String?>? original
  }) {
    return Item._internal(
      id: id,
      sku: sku == null ? this.sku : sku.value,
      categories: categories == null ? this.categories : categories.value,
      description: description == null ? this.description : description.value,
      details: details == null ? this.details : details.value,
      images: images == null ? this.images : images.value,
      quality: quality == null ? this.quality : quality.value,
      split: split == null ? this.split : split.value,
      status: status == null ? this.status : status.value,
      original: original == null ? this.original : original.value
    );
  }
  
  Item.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sku = (json['sku'] as num?)?.toInt(),
      _categories = json['categories']  is Map
        ? (json['categories']['items'] is List
          ? (json['categories']['items'] as List)
              .where((e) => e != null)
              .map((e) => ItemCategory.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['categories'] is List
          ? (json['categories'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ItemCategory.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _description = json['description'],
      _details = json['details'],
      _images = json['images']?.cast<String>(),
      _quality = amplify_core.enumFromString<ItemQuality>(json['quality'], ItemQuality.values),
      _split = (json['split'] as num?)?.toInt(),
      _status = amplify_core.enumFromString<ItemStatus>(json['status'], ItemStatus.values),
      _original = json['original'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sku': _sku, 'categories': _categories?.map((ItemCategory? e) => e?.toJson()).toList(), 'description': _description, 'details': _details, 'images': _images, 'quality': amplify_core.enumToString(_quality), 'split': _split, 'status': amplify_core.enumToString(_status), 'original': _original, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'sku': _sku,
    'categories': _categories,
    'description': _description,
    'details': _details,
    'images': _images,
    'quality': _quality,
    'split': _split,
    'status': _status,
    'original': _original,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ItemModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ItemModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SKU = amplify_core.QueryField(fieldName: "sku");
  static final CATEGORIES = amplify_core.QueryField(
    fieldName: "categories",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ItemCategory'));
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final DETAILS = amplify_core.QueryField(fieldName: "details");
  static final IMAGES = amplify_core.QueryField(fieldName: "images");
  static final QUALITY = amplify_core.QueryField(fieldName: "quality");
  static final SPLIT = amplify_core.QueryField(fieldName: "split");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final ORIGINAL = amplify_core.QueryField(fieldName: "original");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Item";
    modelSchemaDefinition.pluralName = "Items";
    
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
      key: Item.SKU,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Item.CATEGORIES,
      isRequired: false,
      ofModelName: 'ItemCategory',
      associatedKey: ItemCategory.ITEM
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.DESCRIPTION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.DETAILS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.IMAGES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.QUALITY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.SPLIT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.ORIGINAL,
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

class _ItemModelType extends amplify_core.ModelType<Item> {
  const _ItemModelType();
  
  @override
  Item fromJson(Map<String, dynamic> jsonData) {
    return Item.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Item';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Item] in your schema.
 */
class ItemModelIdentifier implements amplify_core.ModelIdentifier<Item> {
  final String id;

  /** Create an instance of ItemModelIdentifier using [id] the primary key. */
  const ItemModelIdentifier({
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
  String toString() => 'ItemModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ItemModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}