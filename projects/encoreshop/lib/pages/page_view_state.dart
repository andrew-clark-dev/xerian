import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_validation/form_validation.dart';

const readOnlyStyle = TextStyle(color: Colors.deepPurpleAccent);

abstract class PageViewState<T extends StatefulWidget> extends State<T> {
  final formKey = GlobalKey<FormState>();
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  late final controllers = <QueryField, TextEditingController>{};
  late final booleanStates = <QueryField, bool>{};
  late final enumStates = <QueryField, String>{};

  late final bool update;

  final NumberFormat formatter = NumberFormat("00000000");
//  final CounterService counter = CounterService(Item.classType);

  final emailValidator = Validator(validators: [const EmailValidator()]);
  final phoneValidator = Validator(validators: [const PhoneNumberValidator()]);
  final requiredValidator = Validator(validators: [const RequiredValidator()]);

  TextFormField text(QueryField field, String labelText, {bool readOnly = false}) => TextFormField(
      controller: controllers[field],
      decoration: InputDecoration(
        labelText: labelText,
      ),
      readOnly: readOnly,
      style: readOnly ? readOnlyStyle : null);

  DropdownButtonFormField dropDown(QueryField field, String labelText, List<dynamic> enumValues) =>
      DropdownButtonFormField<String?>(
          decoration: InputDecoration(
            labelText: labelText,
          ),
          value: enumStates[field],
          hint: const Text('Select an option'),
          onChanged: (String? enumValue) {
            setState(() {
              enumStates[field] = enumValue!;
            });
          },
          validator: (String? enumValue) {
            if (enumValue == null) {
              return 'Please select a value';
            }
            return null;
          },
          items: menuItems(enumValues));

  List<DropdownMenuItem<String>> menuItems(List<dynamic> enumValues) {
    final List<String> list = enumValues.map((v) => (v as Enum).name).toList();
    return list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  FormField switcher(QueryField field, String labelText) {
    return FormField(
        key: null,
        initialValue: false,
        builder: (FormFieldState<dynamic> fieldState) {
          return InputDecorator(
              decoration: InputDecoration(
                labelText: labelText,
              ),
              textAlign: TextAlign.left,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        // This bool value toggles the switch.
                        value: booleanStates[field]!,
                        onChanged: (bool b) {
                          setState(() {
                            booleanStates[field] = b;
                          });
                        },
                      ))));
        });
  }
}
