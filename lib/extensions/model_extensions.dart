import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/widgets/model_list_view.dart';
import 'package:xerian/widgets/model_ui_config.dart';
import 'package:xerian/widgets/model_view.dart';

extension ModelTypeExtensions on ModelType {
  String get viewPath => '/${modelName().toLowerCase()}';
  String get listPath => '/${modelName().toLowerCase()}list';
  String get formPath => '/${modelName().toLowerCase()}form';

  ModelSchema get schema {
    return ModelProvider.instance.modelSchemas
        .firstWhere((e) => e.name == modelName());
  }

  GoRoute route({Widget? page, bool? isList, String? path}) {
    return GoRoute(
      path: _path(path, isList),
      builder: (BuildContext context, GoRouterState state) {
        return _target(page, isList, state);
      },
    );
  }

  String _path(String? path, bool? isList) {
    if (path != null) return path;
    if (isList ?? false) return listPath;
    return viewPath;
  }

  Widget _target(Widget? page, bool? isList, GoRouterState? state) {
    if (page != null) return page;
    if (isList ?? false) return ModelListView(this);
    if (state?.extra == null) {
      return ModelView(this);
    } else {
      return ModelView(this, model: state!.extra as Model);
    }
  }
}

extension ModelFieldExtensions on ModelField {
  ModelFieldTypeEnum fieldType() => type.fieldType;
  bool isString() => fieldType() == ModelFieldTypeEnum.string;
  bool isText() => !{ModelFieldTypeEnum.bool, ModelFieldTypeEnum.enumeration}
      .contains(fieldType());
  bool isDate() => !{ModelFieldTypeEnum.date, ModelFieldTypeEnum.dateTime}
      .contains(fieldType());
  bool isDouble() => fieldType() == ModelFieldTypeEnum.double;
  bool isInt() => fieldType() == ModelFieldTypeEnum.int;
  bool isBool() => fieldType() == ModelFieldTypeEnum.bool;
  bool isEnum() => fieldType() == ModelFieldTypeEnum.enumeration;
  bool isAutoSet() {
    if (isReadOnly) return true;
    if (ModelUiConfig.autosetFields.contains(name)) return true;
    return false;
  }
}
