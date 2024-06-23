import 'package:amplify_core/amplify_core.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:xerian/model_config.dart';
import 'package:xerian/services/model_extensions.dart';

const autosetFields = ['number', 'sku'];
const hideFields = ['id', 'original'];

class ModelFormFieldFactory {
  late final _textEditingControllers = <String, TextEditingController>{};
  late final _booleanState = <String, bool>{};
  late final _enumState = <String, String>{};
  late final ModelConfig _config;

  late final List<ModelField> _fields;

  late final FormFieldState<bool> x;

  ModelFormFieldFactory(ModelType modelType, {Model? model}) {
    _config = ModelConfig(modelType);
    _fields = modelType
        .schema()
        .fields!
        .values
        .where((v) => !hideFields.contains(v.name))
        .toList();
    for (var value in _fields) {
      if (value.isText()) {
        _textEditingControllers[value.name] = TextEditingController();
      }
      if (value.isBool()) _booleanState[value.name] = false;
      if (value.isEnum()) _enumState[value.name] = "";
    }

    if (model != null) {
      final json = model.toJson();
      for (var value in _fields) {
        if (value.isText()) {
          _textEditingControllers[value.name]!.text =
              (json[value.name] ?? '') as String;
        }
        if (value.isBool()) {
          _booleanState[value.name] = (json[value.name] ?? false) as bool;
        }
        if (value.isEnum()) {
          _enumState[value.name] = (json[value.name] ?? '') as String;
        }
      }
    }
  }
  TextFormField text(ModelField value) => TextFormField(
      controller: _textEditingControllers[value.name],
      decoration: InputDecoration(
        labelText: value.name.toCapitalCase(),
      ));

  DropdownButtonFormField dropDown(ModelField value) =>
      DropdownButtonFormField<String?>(
          decoration: InputDecoration(
            labelText: value.name.toCapitalCase(),
          ),
          value: _enumState[value.name]! == '' ? null : _enumState[value.name]!,
          hint: const Text('Select an option'),
          onChanged: (String? enumValue) {
            _enumState[value.name] = enumValue!;
          },
          validator: (String? enumValue) {
            if (enumValue == null) {
              return 'Please select a value';
            }
            return null;
          },
          items: _config
              .enumValues(value.name)
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList());

  FormField switcher(ModelField value) {
    return FormField(
        key: null,
        initialValue: false,
        builder: (FormFieldState<dynamic> field) {
          return InputDecorator(
              decoration: InputDecoration(
                labelText: value.name.toCapitalCase(),
              ),
              textAlign: TextAlign.left,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Switch(
                    // This bool value toggles the switch.
                    value: _booleanState[value.name]!,
                    activeColor: Colors.red,
                    onChanged: (bool b) => _booleanState[value.name] = b),
              ));
        });
  }

  List<FormField> formFields() {
    List<FormField> result = [];
    for (var value in _fields) {
      FormField? formField;
      if (value.isText()) formField = text(value);
      if (value.isBool()) formField = switcher(value);
      if (value.isEnum()) formField = dropDown(value);

      if (formField != null) result.add(formField);
    }
    return result;
  }
}
