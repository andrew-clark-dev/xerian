import 'dart:convert';

import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:contextual_logging/contextual_logging.dart';
import 'package:encore_shop/src/pages/entity.dart';
import 'package:uuid/uuid.dart';

import 'aws_services.dart';

class Repository with ContextualLogger {
  final AWSServices aws = AWSServices();
  final String _tableName;
  final Entity Function(Map<String, dynamic>) _fromJson;

  Map<String, AttributeValue>? _lastEvaluatedKey;

  factory Repository(
      tableName, Entity Function(Map<String, dynamic>) fromJson) {
    return Repository._privateConstructor(tableName, fromJson);
  }

  Repository._privateConstructor(this._tableName, this._fromJson);

  // Future<List<Entity>> getNextPage() async {
  //   final scanResponse = await aws.dynamoDB.getItem(
  //     tableName: _tableName,
  //     limit: 100, // Adjust the limit based on your needs
  //     exclusiveStartKey: _lastEvaluatedKey,
  //   );
  //   if (scanResponse == null) return []; // is this needed, @TODO

  //   // Update the last evaluated key for the next page
  //   _lastEvaluatedKey = scanResponse.lastEvaluatedKey;

  //   // Process the results with the given entity conversion
  //   List<Entity> results = scanResponse.items
  //       .map((item) => _fromJson(jsonDecode(item['entity'].s)));
  //   return results;
  // }

  Future<List<dynamic>> getNextPage() async {
    try {
      final scanResponse = await aws.dynamoDB.scan(
        tableName: _tableName,
        limit: 100, // Adjust the limit based on your needs
        exclusiveStartKey: _lastEvaluatedKey,
      );
      if (scanResponse == null) return []; // is this needed, @TODO

      // Update the last evaluated key for the next page
      _lastEvaluatedKey = scanResponse.lastEvaluatedKey;

      // Process the results with the given entity conversion
      final items = scanResponse.items
          .map((item) => jsonDecode(item['entity'].s))
          .toList();

      return items;
    } on Exception catch (e) {
      log.e("Cannot scan db, excaption: $e");
      rethrow;
    }
  }

  Future<Entity> get(Uuid id) async {
    // Retrieve the item, from the given table
    final item = await aws.dynamoDB.getItem(
        key: {'id': AttributeValue(s: id.toString())},
        tableName: _tableName).item;

    // Process the results with the given entity conversion
    return _fromJson(item['entity'].s);
  }

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
