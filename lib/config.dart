import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xerian/models/Account.dart';
import 'package:xerian/services/model_extensions.dart';
import 'package:xerian/widgets/model_list_view.dart';
import 'package:xerian/widgets/model_view.dart';

class Config {
  static final modelConfig = {
    Account.classType: {
      'listFields': const [
        'number',
        'firstName',
        'lastName',
        'phoneNumber',
        'email',
        'balance',
        'comunicationPreferences'
      ]
    }
  };

  static GoRoute listRoute(ModelType modelType) {
    return GoRoute(
      path: modelType.listPath(),
      builder: (BuildContext context, GoRouterState state) {
        return ModelListView(modelType, modelConfig[modelType]!['listFields']!);
      },
    );
  }

  static GoRoute viewRoute(ModelType modelType) {
    return GoRoute(
      path: modelType.path(),
      builder: (BuildContext context, GoRouterState state) {
        if (state.extra == null) {
          return ModelView(modelType);
        }
        return ModelView(modelType, model: state.extra as Model);
      },
    );
  }

  static GoRoute route(ModelType modelType, Widget page) {
    return GoRoute(
      path: modelType.path(),
      builder: (BuildContext context, GoRouterState state) {
        return page;
      },
    );
  }
}
