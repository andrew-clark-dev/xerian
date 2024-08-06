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
  final String? _sku;
  final String? _title;
  final Account? _account;
  final String? _accountNumber;
  final String? _category;
  final String? _brand;
  final String? _color;
  final String? _size;
  final String? _description;
  final String? _details;
  final List<String>? _images;
  final ItemCondition? _condition;
  final int? _quantity;
  final int? _split;
  final double? _price;
  final ItemStatus? _status;
  final amplify_core.TemporalDateTime? _printedAt;
  final String? _metadata;
  final bool? _active;
  final amplify_core.TemporalDateTime? _updatedAt;
  final amplify_core.TemporalDateTime? _createdAt;

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
  
  String get sku {
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
  
  String? get title {
    return _title;
  }
  
  Account? get account {
    return _account;
  }
  
  String? get accountNumber {
    return _accountNumber;
  }
  
  String get category {
    try {
      return _category!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get brand {
    return _brand;
  }
  
  String? get color {
    return _color;
  }
  
  String? get size {
    return _size;
  }
  
  String? get description {
    return _description;
  }
  
  String? get details {
    return _details;
  }
  
  List<String>? get images {
    return _images;
  }
  
  ItemCondition? get condition {
    return _condition;
  }
  
  int get quantity {
    try {
      return _quantity!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get split {
    try {
      return _split!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get price {
    try {
      return _price!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  ItemStatus? get status {
    return _status;
  }
  
  amplify_core.TemporalDateTime? get printedAt {
    return _printedAt;
  }
  
  String? get metadata {
    return _metadata;
  }
  
  bool? get active {
    return _active;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  const Item._internal({required this.id, required sku, title, account, accountNumber, required category, brand, color, size, description, details, images, condition, required quantity, required split, required price, status, printedAt, metadata, active, updatedAt, createdAt}): _sku = sku, _title = title, _account = account, _accountNumber = accountNumber, _category = category, _brand = brand, _color = color, _size = size, _description = description, _details = details, _images = images, _condition = condition, _quantity = quantity, _split = split, _price = price, _status = status, _printedAt = printedAt, _metadata = metadata, _active = active, _updatedAt = updatedAt, _createdAt = createdAt;
  
  factory Item({String? id, required String sku, String? title, Account? account, String? accountNumber, required String category, String? brand, String? color, String? size, String? description, String? details, List<String>? images, ItemCondition? condition, required int quantity, required int split, required double price, ItemStatus? status, amplify_core.TemporalDateTime? printedAt, String? metadata, bool? active, amplify_core.TemporalDateTime? updatedAt}) {
    return Item._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      sku: sku,
      title: title,
      account: account,
      accountNumber: accountNumber,
      category: category,
      brand: brand,
      color: color,
      size: size,
      description: description,
      details: details,
      images: images != null ? List<String>.unmodifiable(images) : images,
      condition: condition,
      quantity: quantity,
      split: split,
      price: price,
      status: status,
      printedAt: printedAt,
      metadata: metadata,
      active: active,
      updatedAt: updatedAt);
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
      _title == other._title &&
      _account == other._account &&
      _accountNumber == other._accountNumber &&
      _category == other._category &&
      _brand == other._brand &&
      _color == other._color &&
      _size == other._size &&
      _description == other._description &&
      _details == other._details &&
      DeepCollectionEquality().equals(_images, other._images) &&
      _condition == other._condition &&
      _quantity == other._quantity &&
      _split == other._split &&
      _price == other._price &&
      _status == other._status &&
      _printedAt == other._printedAt &&
      _metadata == other._metadata &&
      _active == other._active &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Item {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sku=" + "$_sku" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("account=" + (_account != null ? _account.toString() : "null") + ", ");
    buffer.write("accountNumber=" + "$_accountNumber" + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("brand=" + "$_brand" + ", ");
    buffer.write("color=" + "$_color" + ", ");
    buffer.write("size=" + "$_size" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("details=" + "$_details" + ", ");
    buffer.write("images=" + (_images != null ? _images.toString() : "null") + ", ");
    buffer.write("condition=" + (_condition != null ? amplify_core.enumToString(_condition)! : "null") + ", ");
    buffer.write("quantity=" + (_quantity != null ? _quantity.toString() : "null") + ", ");
    buffer.write("split=" + (_split != null ? _split.toString() : "null") + ", ");
    buffer.write("price=" + (_price != null ? _price.toString() : "null") + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("printedAt=" + (_printedAt != null ? _printedAt.format() : "null") + ", ");
    buffer.write("metadata=" + "$_metadata" + ", ");
    buffer.write("active=" + (_active != null ? _active.toString() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Item copyWith({String? sku, String? title, Account? account, String? accountNumber, String? category, String? brand, String? color, String? size, String? description, String? details, List<String>? images, ItemCondition? condition, int? quantity, int? split, double? price, ItemStatus? status, amplify_core.TemporalDateTime? printedAt, String? metadata, bool? active, amplify_core.TemporalDateTime? updatedAt}) {
    return Item._internal(
      id: id,
      sku: sku ?? this.sku,
      title: title ?? this.title,
      account: account ?? this.account,
      accountNumber: accountNumber ?? this.accountNumber,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      color: color ?? this.color,
      size: size ?? this.size,
      description: description ?? this.description,
      details: details ?? this.details,
      images: images ?? this.images,
      condition: condition ?? this.condition,
      quantity: quantity ?? this.quantity,
      split: split ?? this.split,
      price: price ?? this.price,
      status: status ?? this.status,
      printedAt: printedAt ?? this.printedAt,
      metadata: metadata ?? this.metadata,
      active: active ?? this.active,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  Item copyWithModelFieldValues({
    ModelFieldValue<String>? sku,
    ModelFieldValue<String?>? title,
    ModelFieldValue<Account?>? account,
    ModelFieldValue<String?>? accountNumber,
    ModelFieldValue<String>? category,
    ModelFieldValue<String?>? brand,
    ModelFieldValue<String?>? color,
    ModelFieldValue<String?>? size,
    ModelFieldValue<String?>? description,
    ModelFieldValue<String?>? details,
    ModelFieldValue<List<String>?>? images,
    ModelFieldValue<ItemCondition?>? condition,
    ModelFieldValue<int>? quantity,
    ModelFieldValue<int>? split,
    ModelFieldValue<double>? price,
    ModelFieldValue<ItemStatus?>? status,
    ModelFieldValue<amplify_core.TemporalDateTime?>? printedAt,
    ModelFieldValue<String?>? metadata,
    ModelFieldValue<bool?>? active,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return Item._internal(
      id: id,
      sku: sku == null ? this.sku : sku.value,
      title: title == null ? this.title : title.value,
      account: account == null ? this.account : account.value,
      accountNumber: accountNumber == null ? this.accountNumber : accountNumber.value,
      category: category == null ? this.category : category.value,
      brand: brand == null ? this.brand : brand.value,
      color: color == null ? this.color : color.value,
      size: size == null ? this.size : size.value,
      description: description == null ? this.description : description.value,
      details: details == null ? this.details : details.value,
      images: images == null ? this.images : images.value,
      condition: condition == null ? this.condition : condition.value,
      quantity: quantity == null ? this.quantity : quantity.value,
      split: split == null ? this.split : split.value,
      price: price == null ? this.price : price.value,
      status: status == null ? this.status : status.value,
      printedAt: printedAt == null ? this.printedAt : printedAt.value,
      metadata: metadata == null ? this.metadata : metadata.value,
      active: active == null ? this.active : active.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  Item.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sku = json['sku'],
      _title = json['title'],
      _account = json['account'] != null
        ? json['account']['serializedData'] != null
          ? Account.fromJson(new Map<String, dynamic>.from(json['account']['serializedData']))
          : Account.fromJson(new Map<String, dynamic>.from(json['account']))
        : null,
      _accountNumber = json['accountNumber'],
      _category = json['category'],
      _brand = json['brand'],
      _color = json['color'],
      _size = json['size'],
      _description = json['description'],
      _details = json['details'],
      _images = json['images']?.cast<String>(),
      _condition = amplify_core.enumFromString<ItemCondition>(json['condition'], ItemCondition.values),
      _quantity = (json['quantity'] as num?)?.toInt(),
      _split = (json['split'] as num?)?.toInt(),
      _price = (json['price'] as num?)?.toDouble(),
      _status = amplify_core.enumFromString<ItemStatus>(json['status'], ItemStatus.values),
      _printedAt = json['printedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['printedAt']) : null,
      _metadata = json['metadata'],
      _active = json['active'],
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sku': _sku, 'title': _title, 'account': _account?.toJson(), 'accountNumber': _accountNumber, 'category': _category, 'brand': _brand, 'color': _color, 'size': _size, 'description': _description, 'details': _details, 'images': _images, 'condition': amplify_core.enumToString(_condition), 'quantity': _quantity, 'split': _split, 'price': _price, 'status': amplify_core.enumToString(_status), 'printedAt': _printedAt?.format(), 'metadata': _metadata, 'active': _active, 'updatedAt': _updatedAt?.format(), 'createdAt': _createdAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'sku': _sku,
    'title': _title,
    'account': _account,
    'accountNumber': _accountNumber,
    'category': _category,
    'brand': _brand,
    'color': _color,
    'size': _size,
    'description': _description,
    'details': _details,
    'images': _images,
    'condition': _condition,
    'quantity': _quantity,
    'split': _split,
    'price': _price,
    'status': _status,
    'printedAt': _printedAt,
    'metadata': _metadata,
    'active': _active,
    'updatedAt': _updatedAt,
    'createdAt': _createdAt
  };

  static final amplify_core.QueryModelIdentifier<ItemModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ItemModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SKU = amplify_core.QueryField(fieldName: "sku");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final ACCOUNT = amplify_core.QueryField(
    fieldName: "account",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Account'));
  static final ACCOUNTNUMBER = amplify_core.QueryField(fieldName: "accountNumber");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final BRAND = amplify_core.QueryField(fieldName: "brand");
  static final COLOR = amplify_core.QueryField(fieldName: "color");
  static final SIZE = amplify_core.QueryField(fieldName: "size");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final DETAILS = amplify_core.QueryField(fieldName: "details");
  static final IMAGES = amplify_core.QueryField(fieldName: "images");
  static final CONDITION = amplify_core.QueryField(fieldName: "condition");
  static final QUANTITY = amplify_core.QueryField(fieldName: "quantity");
  static final SPLIT = amplify_core.QueryField(fieldName: "split");
  static final PRICE = amplify_core.QueryField(fieldName: "price");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final PRINTEDAT = amplify_core.QueryField(fieldName: "printedAt");
  static final METADATA = amplify_core.QueryField(fieldName: "metadata");
  static final ACTIVE = amplify_core.QueryField(fieldName: "active");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
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
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["sku"], name: "itemsBySku"),
      amplify_core.ModelIndex(fields: const ["accountId"], name: "itemsByAccountId")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.SKU,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Item.ACCOUNT,
      isRequired: false,
      targetNames: ['accountId'],
      ofModelName: 'Account'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.ACCOUNTNUMBER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.CATEGORY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.BRAND,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.COLOR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.SIZE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.DESCRIPTION,
      isRequired: false,
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
      key: Item.CONDITION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.QUANTITY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.SPLIT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.PRICE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.PRINTEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.METADATA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.ACTIVE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Item.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
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