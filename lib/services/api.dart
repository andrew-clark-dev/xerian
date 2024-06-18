import 'package:logging/logging.dart';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart';

class Api {
  final Logger log = Logger("ModelApi");
  final ModelType modelType;

  Api(this.modelType);

  Future<PaginatedResult<Model>?> fetch(PaginatedResult<Model>? page,
      {QueryPredicate<Model>? query}) async {
    try {
      GraphQLRequest<PaginatedResult<Model>> request;
      if (page == null) {
        request = ModelQueries.list(modelType, where: query);
      } else {
        request = page.requestForNextResult!;
      }
      final response = await Amplify.API.query(request: request).response;
      if (response.hasErrors) {
        log.severe('Query return errors: ${response.errors}');
        throw 'Query return errors: ${response.errors}';
      }

      return response.data;
    } on ApiException catch (e) {
      log.severe('Query failed: $e');
      rethrow;
    }
  }
}
