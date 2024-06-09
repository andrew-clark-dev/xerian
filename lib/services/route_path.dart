import 'package:amplify_core/amplify_core.dart';

class RoutePath {
  static String listPath(ModelType modelType) {
    return '/${modelType.modelName().toLowerCase()}list';
  }

  static String path(ModelType modelType) {
    return '/${modelType.modelName().toLowerCase()}';
  }

  static String formPath(ModelType modelType) {
    return '/${modelType.modelName().toLowerCase()}form';
  }
}
