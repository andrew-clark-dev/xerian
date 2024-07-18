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


/** This is an auto generated class representing the Account type in your schema. */
class Account extends amplify_core.Model {
  static const classType = const _AccountModelType();
  final String id;
  final String? _number;
  final String? _firstName;
  final String? _lastName;
  final String? _email;
  final String? _phoneNumber;
  final bool? _isMobile;
  final String? _address;
  final String? _city;
  final String? _state;
  final String? _postcode;
  final double? _balance;
  final AccountComunicationPreferences? _comunicationPreferences;
  final AccountStatus? _status;
  final String? _metadata;
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
  
  String get number {
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
  
  bool? get isMobile {
    return _isMobile;
  }
  
  String? get address {
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
  
  double? get balance {
    return _balance;
  }
  
  AccountComunicationPreferences? get comunicationPreferences {
    return _comunicationPreferences;
  }
  
  AccountStatus? get status {
    return _status;
  }
  
  String? get metadata {
    return _metadata;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Account._internal({required this.id, required number, required firstName, lastName, email, phoneNumber, isMobile, address, city, state, postcode, balance, comunicationPreferences, status, metadata, createdAt, updatedAt}): _number = number, _firstName = firstName, _lastName = lastName, _email = email, _phoneNumber = phoneNumber, _isMobile = isMobile, _address = address, _city = city, _state = state, _postcode = postcode, _balance = balance, _comunicationPreferences = comunicationPreferences, _status = status, _metadata = metadata, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Account({String? id, required String number, required String firstName, String? lastName, String? email, String? phoneNumber, bool? isMobile, String? address, String? city, String? state, String? postcode, double? balance, AccountComunicationPreferences? comunicationPreferences, AccountStatus? status, String? metadata}) {
    return Account._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      number: number,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      isMobile: isMobile,
      address: address,
      city: city,
      state: state,
      postcode: postcode,
      balance: balance,
      comunicationPreferences: comunicationPreferences,
      status: status,
      metadata: metadata);
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
      _isMobile == other._isMobile &&
      _address == other._address &&
      _city == other._city &&
      _state == other._state &&
      _postcode == other._postcode &&
      _balance == other._balance &&
      _comunicationPreferences == other._comunicationPreferences &&
      _status == other._status &&
      _metadata == other._metadata;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Account {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("number=" + "$_number" + ", ");
    buffer.write("firstName=" + "$_firstName" + ", ");
    buffer.write("lastName=" + "$_lastName" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("phoneNumber=" + "$_phoneNumber" + ", ");
    buffer.write("isMobile=" + (_isMobile != null ? _isMobile!.toString() : "null") + ", ");
    buffer.write("address=" + "$_address" + ", ");
    buffer.write("city=" + "$_city" + ", ");
    buffer.write("state=" + "$_state" + ", ");
    buffer.write("postcode=" + "$_postcode" + ", ");
    buffer.write("balance=" + (_balance != null ? _balance!.toString() : "null") + ", ");
    buffer.write("comunicationPreferences=" + (_comunicationPreferences != null ? amplify_core.enumToString(_comunicationPreferences)! : "null") + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("metadata=" + "$_metadata" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Account copyWith({String? number, String? firstName, String? lastName, String? email, String? phoneNumber, bool? isMobile, String? address, String? city, String? state, String? postcode, double? balance, AccountComunicationPreferences? comunicationPreferences, AccountStatus? status, String? metadata}) {
    return Account._internal(
      id: id,
      number: number ?? this.number,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isMobile: isMobile ?? this.isMobile,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      postcode: postcode ?? this.postcode,
      balance: balance ?? this.balance,
      comunicationPreferences: comunicationPreferences ?? this.comunicationPreferences,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata);
  }
  
  Account copyWithModelFieldValues({
    ModelFieldValue<String>? number,
    ModelFieldValue<String>? firstName,
    ModelFieldValue<String?>? lastName,
    ModelFieldValue<String?>? email,
    ModelFieldValue<String?>? phoneNumber,
    ModelFieldValue<bool?>? isMobile,
    ModelFieldValue<String?>? address,
    ModelFieldValue<String?>? city,
    ModelFieldValue<String?>? state,
    ModelFieldValue<String?>? postcode,
    ModelFieldValue<double?>? balance,
    ModelFieldValue<AccountComunicationPreferences?>? comunicationPreferences,
    ModelFieldValue<AccountStatus?>? status,
    ModelFieldValue<String?>? metadata
  }) {
    return Account._internal(
      id: id,
      number: number == null ? this.number : number.value,
      firstName: firstName == null ? this.firstName : firstName.value,
      lastName: lastName == null ? this.lastName : lastName.value,
      email: email == null ? this.email : email.value,
      phoneNumber: phoneNumber == null ? this.phoneNumber : phoneNumber.value,
      isMobile: isMobile == null ? this.isMobile : isMobile.value,
      address: address == null ? this.address : address.value,
      city: city == null ? this.city : city.value,
      state: state == null ? this.state : state.value,
      postcode: postcode == null ? this.postcode : postcode.value,
      balance: balance == null ? this.balance : balance.value,
      comunicationPreferences: comunicationPreferences == null ? this.comunicationPreferences : comunicationPreferences.value,
      status: status == null ? this.status : status.value,
      metadata: metadata == null ? this.metadata : metadata.value
    );
  }
  
  Account.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _number = json['number'],
      _firstName = json['firstName'],
      _lastName = json['lastName'],
      _email = json['email'],
      _phoneNumber = json['phoneNumber'],
      _isMobile = json['isMobile'],
      _address = json['address'],
      _city = json['city'],
      _state = json['state'],
      _postcode = json['postcode'],
      _balance = (json['balance'] as num?)?.toDouble(),
      _comunicationPreferences = amplify_core.enumFromString<AccountComunicationPreferences>(json['comunicationPreferences'], AccountComunicationPreferences.values),
      _status = amplify_core.enumFromString<AccountStatus>(json['status'], AccountStatus.values),
      _metadata = json['metadata'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'number': _number, 'firstName': _firstName, 'lastName': _lastName, 'email': _email, 'phoneNumber': _phoneNumber, 'isMobile': _isMobile, 'address': _address, 'city': _city, 'state': _state, 'postcode': _postcode, 'balance': _balance, 'comunicationPreferences': amplify_core.enumToString(_comunicationPreferences), 'status': amplify_core.enumToString(_status), 'metadata': _metadata, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'number': _number,
    'firstName': _firstName,
    'lastName': _lastName,
    'email': _email,
    'phoneNumber': _phoneNumber,
    'isMobile': _isMobile,
    'address': _address,
    'city': _city,
    'state': _state,
    'postcode': _postcode,
    'balance': _balance,
    'comunicationPreferences': _comunicationPreferences,
    'status': _status,
    'metadata': _metadata,
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
  static final ISMOBILE = amplify_core.QueryField(fieldName: "isMobile");
  static final ADDRESS = amplify_core.QueryField(fieldName: "address");
  static final CITY = amplify_core.QueryField(fieldName: "city");
  static final STATE = amplify_core.QueryField(fieldName: "state");
  static final POSTCODE = amplify_core.QueryField(fieldName: "postcode");
  static final BALANCE = amplify_core.QueryField(fieldName: "balance");
  static final COMUNICATIONPREFERENCES = amplify_core.QueryField(fieldName: "comunicationPreferences");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final METADATA = amplify_core.QueryField(fieldName: "metadata");
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
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["number"], name: "accountsByNumber")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.NUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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
      key: Account.ISMOBILE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.ADDRESS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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
      key: Account.BALANCE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.COMUNICATIONPREFERENCES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Account.METADATA,
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