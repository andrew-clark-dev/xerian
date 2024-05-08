import 'package:encore_shop/src/pages/entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

/// This allows the `Account` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'account.g.dart';

Uuid uuid = const Uuid();

@JsonSerializable()
class Account implements NumberedEntity {
  Account(
      {String? id,
      required this.number,
      required this.firstName,
      required this.lastName,
      this.phone,
      this.email,
      this.address})
      : id = id ?? uuid.v1();

  @override
  late String id;
  @override
  final int number;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;
  final String? address;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  // Use the factory constructor above to process a list of json (typically returned from dynamodb)
  static List<Account> fromJsonList(List<dynamic> list) {
    return list.map((item) => Account.fromJson(item)).toList();
  }

  // Method to clone an account with optional parameters
  Account copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
  }) {
    return Account(
      id: id,
      number: number,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}
