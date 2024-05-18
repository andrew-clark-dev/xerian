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


/** This is an auto generated class representing the Account type in your schema. */
class Account extends amplify_core.Model {
  static const classType = const _AccountModelType();
  final String id;
  final int? _number;
  final String? _firstName;
  final String? _lastName;
  final String? _email;
  final String? _phoneNumber;
  final List<String>? _address;
  final String? _city;
  final String? _state;
  final String? _postcode;
  final int? _split;
  final List<Item>? _items;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AccountModelIdentifier get modelIdentifier {
      return AccountModelIdentifier(
        id: id
      );
  }
  
  int get number {
    try {
      return _number!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get firstName {
    try {
      return _firstName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get lastName {
    return _lastName;
  }
  
  String? get email {
    return _email;
  }
  
  String? get phoneNumber {
    return _phoneNumber;
  }
  
  List<String>? get address {
    return _address;
  }
  
  String? get city {
    return _city;
  }
  
  String? get state {
    return _state;
  }
  
  String? get postcode {
    return _postcode;
  }
  
  int? get split {
    return _split;
  }
  
  List<Item>? get items {
    return _items;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Account._internal({required this.id, required number, required firstName, lastName, email, phoneNumber, address, city, state, postcode, split, items, createdAt, updatedAt}): _number = number, _firstName = firstName, _lastName = lastName, _email = email, _phoneNumber = phoneNumber, _address = address, _city = city, _state = state, _postcode = postcode, _split = split, _items = items, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Account({String? id, required int number, required String firstName, String? lastName, String? email, String? phoneNumber, List<String>? address, String? city, String? state, String? postcode, int? split, List<Item>? items}) {
    return Account._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      number: number,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      address: address != null ? List<String>.unmodifiable(address) : address,
      city: city,
      state: state,
      postcode: postcode,
      split: split,
      items: items != null ? List<Item>.unmodifiable(items) : items);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Account &&
      id == other.id &&
      _number == other._number &&
      _firstName == other._firstName &&
      _lastName == other._lastName &&
      _email == other._email &&
      _phoneNumber == other._phoneNumber &&
      DeepCollectionEquality().equals(_address, other._address) &&
      _city == other._city &&
      _state == other._state &&
      _postcode == other._postcode &&
      _split == other._split &&
      DeepCollectionEquality().equals(_items, other._items);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Account {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("number=" + (_number != null ? _number!.toString() : "null") + ", ");
    buffer.write("firstName=" + "$_firstName" + ", ");
    buffer.write("lastName=" + "$_lastName" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("phoneNumber=" + "$_phoneNumber" + ", ");
    buffer.write("address=" + (_address != null ? _address!.toString() : "null") + ", ");
    buffer.write("city=" + "$_city" + ", ");
    buffer.write("state=" + "$_state" + ", ");
    buffer.write("postcode=" + "$_postcode" + ", ");
    buffer.write("split=" + (_split != null ? _split!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Account copyWith({int? number, String? firstName, String? lastName, String? email, String? phoneNumber, List<String>? address, String? city, String? state, String? postcode, int? split, List<Item>? items}) {
    return Account._internal(
      id: id,
      number: number ?? this.number,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      postcode: postcode ?? this.postcode,
      split: split ?? this.split,
      items: items ?? this.items);
  }
  
  Account copyWithModelFieldValues({
    ModelFieldValue<int>? number,
    ModelFieldValue<String>? firstName,
    ModelFieldValue<String?>? lastName,
    ModelFieldValue<String?>? email,
    ModelFieldValue<String?>? phoneNumber,
    ModelFieldValue<List<String>?>? address,
    ModelFieldValue<String?>? city,
    ModelFieldValue<String?>? state,
    ModelFieldValue<String?>? postcode,
    ModelFieldValue<int?>? split,
    ModelFieldValue<List<Item>?>? items
  }) {
    return Account._internal(
      id: id,
      number: number == null ? this.number : number.value,
      firstName: firstName == null ? this.firstName : firstName.value,
      lastName: lastName == null ? this.lastName : lastName.value,
      email: email == null ? this.email : email.value,
      phoneNumber: phoneNumber == null ? this.phoneNumber : phoneNumber.value,
      address: address == null ? this.address : address.value,
      city: city == null ? this.city : city.value,
      state: state == null ? this.state : state.value,
      postcode: postcode == null ? this.postcode : postcode.value,
      split: split == null ? this.split : split.value,
      items: items == null ? this.items : items.value
    );
  }
  
  Account.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _number = (json['number'] as num?)?.toInt(),
      _firstName = json['firstName'],
      _lastName = json['lastName'],
      _email = json['email'],
      _phoneNumber = json['phoneNumber'],
      _address = json['address']?.cast<String>(),
      _city = json['city'],
      _state = json['state'],
      _postcode = json['postcode'],
      _split = (json['split'] as num?)?.toInt(),
      _items = json['items']  is Map
        ? (json['items']['items'] is List
          ? (json['items']['items'] as List)
              .where((e) => e != null)
              .map((e) => Item.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['items'] is List
          ? (json['items'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Item.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'number': _number, 'firstName': _firstName, 'lastName': _lastName, 'email': _email, 'phoneNumber': _phoneNumber, 'address': _address, 'city': _city, 'state': _state, 'postcode': _postcode, 'split': _split, 'items': _items?.map((Item? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'number': _number,
    'firstName': _firstName,
    'lastName': _lastName,
    'email': _email,
    'phoneNumber': _phoneNumber,
    'address': _address,
    'city': _city,
    'state': _state,
    'postcode': _postcode,
    'split': _split,
    'items': _items,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<AccountModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<AccountModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NUMBER = amplify_core.QueryField(fieldName: "number");
  static final FIRSTNAME = amplify_core.QueryField(fieldName: "firstName");
  static final LASTNAME = amplify_core.QueryField(fieldName: "lastName");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final PHONENUMBER = amplify_core.QueryField(fieldName: "phoneNumber");
  static final ADDRESS = amplify_core.QueryField(fieldName: "address");
  static final CITY = amplify_core.QueryField(fieldName: "city");
  static final STATE = amplify_core.QueryField(fieldName: "state");
  static final POSTCODE = amplify_core.QueryField(fieldName: "postcode");
  static final SPLIT = amplify_core.QueryField(fieldName: "split");
  static final ITEMS = amplify_core.QueryField(
    fieldName: "items",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Item'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Account";
    modelSchemaDefinition.pluralName = "Accounts";
    
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
      key: Account.NUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.FIRSTNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.LASTNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.EMAIL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.PHONENUMBER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.ADDRESS,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.CITY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.STATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.POSTCODE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.SPLIT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Account.ITEMS,
      isRequired: false,
      ofModelName: 'Item',
      associatedKey: Item.ACCOUNT
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

class _AccountModelType extends amplify_core.ModelType<Account> {
  const _AccountModelType();
  
  @override
  Account fromJson(Map<String, dynamic> jsonData) {
    return Account.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Account';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Account] in your schema.
 */
class AccountModelIdentifier implements amplify_core.ModelIdentifier<Account> {
  final String id;

  /** Create an instance of AccountModelIdentifier using [id] the primary key. */
  const AccountModelIdentifier({
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
  String toString() => 'AccountModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AccountModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}