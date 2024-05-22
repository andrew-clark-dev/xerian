import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encore_shop/models/Account.dart';
import 'package:encore_shop/models/Counter.dart';
import 'package:encore_shop/models/Item.dart';

class CounterService {
  /// a list of models to provider counters for
  static final List<ModelType> models = [Account.classType, Item.classType];

  static const graphQLDocument = '''
      mutation incrementCounter(\$id: ID!) {
        incrementCounter(id: \$id) {
          id count createdAt updatedAt
        }
      }
    ''';

  final ModelType _model;

  CounterService(this._model);

  static Future<void> _createCounter(id) async {
    try {
      final counter = Counter(id: id, count: 0);
      final request = ModelMutations.create(counter);
      final response = await Amplify.API.mutate(request: request).response;

      final createdCounter = response.data;
      if (createdCounter == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdCounter.id}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  static Future<Counter?> _queryItem(id) async {
    try {
      final request = ModelQueries.get(
        Counter.classType,
        Counter(id: id).modelIdentifier,
      );
      final response = await Amplify.API.query(request: request).response;
      final counter = response.data;
      return counter;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return null;
    }
  }

  static initialize() async {
    for (final model in models) {
      final id = model.modelName();
      if (await _queryItem(id) == null) {
        _createCounter(id);
      }
    }
  }

  /// Atomically increment the counter for the given model (or modelName) and return the incremented value
  Future<Counter> increment() async {
    final incRequest = GraphQLRequest<Counter>(
        document: graphQLDocument,
        variables: <String, String>{"id": _model.modelName()},
        decodePath: 'incrementCounter',
        modelType: Counter.classType);

    final response = await Amplify.API.mutate(request: incRequest).response;
    final count = response.data!;
    return count;
  }

  Future<int> next() async {
    return (await increment()).count!;
  }
}
