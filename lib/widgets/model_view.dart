import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:change_case/change_case.dart';
import 'package:xerian/model_config.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_validation/form_validation.dart';
import 'package:xerian/services/model_extensions.dart';

class ModelView extends StatefulWidget {
  final Model? model;
  final ModelType modelType;

  const ModelView(
    this.modelType, {
    super.key,
    this.model,
  });

  @override
  State<ModelView> createState() => _ModelViewState();
}

class _ModelViewState extends State<ModelView> {
  final _formKey = GlobalKey<FormState>();

  late final _controllers = <String, TextEditingController>{};
  late final _booleanState = <String, bool>{};
  late final _enumState = <String, String?>{};
  late final ModelConfig _config;
  late final Model? _model;
  late final List<ModelField> _fields;
  String _titleText = 'Create ';
  final NumberFormat formatter = NumberFormat("00000000");
//  final CounterService counter = CounterService(Account.classType);

  final emailValidator = Validator(validators: [const EmailValidator()]);
  final phoneValidator = Validator(validators: [const PhoneNumberValidator()]);
  final requiredValidator = Validator(validators: [const RequiredValidator()]);

  @override
  void initState() {
    super.initState();
    _config = ModelConfig(widget.modelType);
    _model = widget.model;
    _fields = _config.viewFields();
    for (var value in _fields) {
      if (value.isText()) _controllers[value.name] = TextEditingController();
      if (value.isBool()) _booleanState[value.name] = false;
      if (value.isEnum()) _enumState[value.name] = null;
    }

    if (_model != null) {
      _titleText = 'Update ';
      final json = _model.toJson();
      for (var value in _fields) {
        if (value.isText()) {
          _controllers[value.name]!.text = (json[value.name] ?? '') as String;
        }
        if (value.isBool()) {
          _booleanState[value.name] = (json[value.name] ?? false) as bool;
        }
        if (value.isEnum()) {
          _enumState[value.name] = json[value.name]?.toString();
        }
      }
    }
  }

  Future<void> _submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    // If the form is valid, submit the data

    // Create a new account entry
    final newAccount = Account(
      number: "",
      firstName: "",
    );

    final request = ModelMutations.create(newAccount);

    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Account details store failed'),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content:
              Text('Account ${newAccount.number} details stored successfully'),
        ),
      );
    }

    // } else {
    //   // Update account instead
    //   final updateAccount = _account!.copyWith(
    //     firstName: firstName,
    //     lastName: lastName.isNotEmpty ? lastName : null,
    //   );
    //   await repo.put(updateAccount);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText + _config.modelType.modelName()),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: _fields.map((f) => formField(f)).toList(),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Form is valid, process the data
                            _submitForm(ScaffoldMessenger.of(context));
                          }
                        },
                        child: Text(_titleText),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FormField formField(ModelField field) {
    switch (field.fieldType()) {
      case ModelFieldTypeEnum.bool:
        return switcher(field);
      case ModelFieldTypeEnum.enumeration:
        return dropDown(field);
      default:
        return text(field);
    }
  }

  TextFormField text(ModelField value) => TextFormField(
      controller: _controllers[value.name],
      decoration: InputDecoration(
        labelText: value.name.toCapitalCase(),
      ));

  DropdownButtonFormField dropDown(ModelField value) =>
      DropdownButtonFormField<String?>(
          decoration: InputDecoration(
            labelText: value.name.toCapitalCase(),
          ),
          value: _enumState[value.name],
          hint: const Text('Select an option'),
          onChanged: (String? enumValue) {
            setState(() {
              _enumState[value.name] = enumValue!;
            });
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
                    onChanged: (bool b) {
                      setState(() {
                        _booleanState[value.name] = b;
                      });
                    },
                  )));
        });
  }
}
