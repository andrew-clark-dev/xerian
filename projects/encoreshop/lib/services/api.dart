import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart';

class Api<T extends Model> {
  final ModelType<T> modelType;

  Api(this.modelType);

  Future<PaginatedResult<T>?> fetch(PaginatedResult<T>? page,
      {QueryPredicate<T>? query}) async {
    try {
      GraphQLRequest<PaginatedResult<T>> request;
      if (page == null) {
        request = ModelQueries.list(modelType, where: query);
      } else {
        request = page.requestForNextResult!;
      }
      final response = await Amplify.API.query(request: request).response;
      if (response.hasErrors) {
        safePrint('Query return errors: ${response.errors}');
        throw 'Query return errors: ${response.errors}';
      }

      return response.data;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      rethrow;
    }
  }
}
