import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/extensions/model_extensions.dart';
import 'package:xerian/widgets/model_list_view.dart';
import 'package:xerian/widgets/model_view.dart';
import 'package:change_case/change_case.dart';

final Logger log = Logger("ModelConfig");

class ModelConfig {
  static const autosetFields = ['number', 'sku', 'balance'];
  static const hideFields = ['id', 'original'];

  final ModelType modelType;

  ModelConfig(this.modelType);

  static final modelConfig = {
    Account.classType: {
      'listFields': [
        ['number'],
        ['firstName'],
        ['lastName'],
        ['phoneNumber'],
        ['email', 'E-Mail'],
        ['balance'],
        ['comunicationPreferences', 'Contact']
      ]
    }
  };

  static final modelTypeConfig = {
    Account.classType: {
      'status': AccountStatus.values,
      'comunicationPreferences': AccountComunicationPreferences.values
    }
  };

  List<String> enumValues(String fieldName) {
    log.info(
        modelTypeConfig[modelType]![fieldName]!.map((v) => v.name).toList());
    return modelTypeConfig[modelType]![fieldName]!.map((v) => v.name).toList();
  }

  List<List<String>>? _get(String name) {
    return modelConfig[modelType]?[name];
  }

  List<ModelField> viewFields() {
    final hide = _get('hideFields')?.map((d) => d[0]).toList() ?? hideFields;
    return modelType.schema.fields!.values
        .where((v) => !hide.contains(v.name))
        .toList();
  }

  List<String> listFieldNames() {
    return _get('listFields')!.map((d) => d[0]).toList();
  }

  List<String> listTitleNames() {
    return _get('listFields')!.map((d) {
      if (d.length > 1) {
        return d[1];
      } else {
        return (d[0]).toCapitalCase();
      }
    }).toList();
  }

  List<String> values(Model model) {
    List<String> result = [];
    for (final field in listFieldNames()) {
      result.add(model.toMap()[field].toString());
    }
    return result;
  }

  GoRoute listRoute() {
    return GoRoute(
      path: modelType.listPath,
      builder: (BuildContext context, GoRouterState state) {
        return ModelListView(modelType);
      },
    );
  }

  GoRoute viewRoute() {
    return GoRoute(
      path: modelType.viewPath,
      builder: (BuildContext context, GoRouterState state) {
        if (state.extra == null) {
          return ModelView(modelType);
        }
        return ModelView(modelType, model: state.extra as Model);
      },
    );
  }

  GoRoute route(Widget page) {
    return GoRoute(
      path: modelType.viewPath,
      builder: (BuildContext context, GoRouterState state) {
        return page;
      },
    );
  }
}
