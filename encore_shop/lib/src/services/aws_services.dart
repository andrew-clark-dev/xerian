import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:encore_shop/src/login/authentication.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AWSServices {
  static AWSServices? _instance;

  final region = dotenv.env['REGION']!;

  factory AWSServices() {
    _instance ??= AWSServices._privateConstructor();
    return _instance!;
  }

  AWSServices._privateConstructor();

  get dynamoDB {
    return DynamoDB(
        region: region, credentials: Authentication().clientCredentials);
  }
}
