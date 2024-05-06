import 'dart:convert';

import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:encore_shop/src/pages/entity.dart';

import 'aws_services.dart';

class Repository {
  final AWSServices aws = AWSServices();
  final String _tableName;

  Repository(this._tableName);

  Future<PutItemOutput> put(Entity entity) async {
    if (entity is NumberedEntity) {
      return _putNumberedEntity(entity);
    }
    return _putEntity(entity);
  }

  Future<PutItemOutput> _putEntity(Entity entity) async {
    return await aws.dynamoDB.putItem(tableName: _tableName, item: {
      'id': AttributeValue(s: entity.id),
      'entity': AttributeValue(s: jsonEncode(entity))
    });
  }

  Future<PutItemOutput> _putNumberedEntity(NumberedEntity entity) async {
    return await aws.dynamoDB.putItem(tableName: _tableName, item: {
      'id': AttributeValue(s: entity.id),
      'number': AttributeValue(n: entity.number.toString()),
      'entity': AttributeValue(s: jsonEncode(entity))
    });
  }
}
