import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:encore_shop/src/login/authentication.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AWSServices {
  static AWSServices? _instance;

  final region = dotenv.env['REGION']!;

  final Authentication _authentication;

  late DynamoDB _dynamoDB;

  factory AWSServices() {
    _instance ??= AWSServices._privateConstructor(Authentication());
    return _instance!;
  }

  AWSServices._privateConstructor(this._authentication) {
    _dynamoDB = DynamoDB(
        region: region, credentials: _authentication.clientCredentials);
  }

  get dynamoDB => _dynamoDB;
}
