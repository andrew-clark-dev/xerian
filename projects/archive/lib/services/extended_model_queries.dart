import 'package:amplify_core/amplify_core.dart';
import 'package:logging/logging.dart';

import '../models/ModelProvider.dart';

class ExtendedModelQueries {
  static Logger log = Logger("ExtendedModelQueries");
  static GraphQLRequest<PaginatedResult<T>> listBy<T extends Model>(
    ModelType<T> modelType,
    ModelIndex modelIndex,
    String value, // Only supports string indexes for now.
    {
    int? limit,
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) {
    ModelProvider provider = ModelProvider.instance;

    final indexField = modelIndex.fields.first;

    final variables = <String, String>{indexField: value};

    final schema = provider.modelSchemas.firstWhere(
        (elem) => elem.name == modelType.modelName(),
        orElse: () => throw ApiOperationException(
            'No schema found for the ModelType provided: ${modelType.modelName()}'));

    final fields = schema.fields!.entries
        .where((entry) => entry.value.association == null)
        .map((entry) => entry.key)
        .toList()
        .join(' ');

    final requestTypeVal = GraphQLRequestType.query.name;
    final requestName =
        '${GraphQLRequestOperation.list.name}${schema.name.capitalized}By${indexField.capitalized}';
    final document =
        '''$requestTypeVal $requestName(\$$indexField: String!) {$requestName($indexField: \$$indexField) { items { $fields } } }''';

    log.fine('Document - $document');

    return GraphQLRequest<PaginatedResult<T>>(
      document: document,
      variables: variables,
      modelType: PaginatedModelType(modelType),
      decodePath: requestName,
      apiName: apiName,
      authorizationMode: authorizationMode,
      headers: headers,
    );
  }
}
