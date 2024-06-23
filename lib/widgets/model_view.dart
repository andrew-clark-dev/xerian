import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:xerian/model_config.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_validation/form_validation.dart';
import 'package:xerian/services/model_extensions.dart';
import 'package:change_case/change_case.dart';

const autosetFields = ['number', 'sku'];
const hideFields = ['id', 'original'];

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
  late final ModelSchema modelSchema = widget.modelType.schema();
  late final String _titleText;
  late final Map<String, ModelField> _fields;
  late final _textEditingControllers = <String, TextEditingController>{};
  late final _booleanState = <String, bool>{};
  late final _enumState = <String, String>{};
  late final ModelConfig _config;

  final NumberFormat formatter = NumberFormat("00000000");
//  final CounterService counter = CounterService(Account.classType);

  final emailValidator = Validator(validators: [const EmailValidator()]);
  final phoneValidator = Validator(validators: [const PhoneNumberValidator()]);
  final requiredValidator = Validator(validators: [const RequiredValidator()]);

  List<ModelField> fields() {
    return _fields.values.where((v) => !hideFields.contains(v.name)).toList();
  }

  @override
  void initState() {
    super.initState();
    _config = ModelConfig(widget.modelType);
    _fields = modelSchema.fields!;
    // Initialize the controllers
    fields().forEach((value) {
      if (value.isText()) {
        _textEditingControllers[value.name] = TextEditingController();
      }
      if (value.isBool()) _booleanState[value.name] = false;
      if (value.isEnum()) _enumState[value.name] = "";
    });

    if (widget.model != null) {
      final json = widget.model!.toJson();
      fields().forEach((value) {
        if (value.isText()) {
          _textEditingControllers[value.name]!.text =
              (json[value.name] ?? '') as String;
        }
        if (value.isBool()) {
          _booleanState[value.name] = (json[value.name] ?? false) as bool;
        }
        if (value.isEnum()) {
          _enumState[value.name] = (json[value.name] ?? '') as String;
          ;
        }
      });
      _titleText = 'Update ${modelSchema.name}';
    } else {
      _titleText = 'Create ${modelSchema.name}';
    }
  }

  @override
  void dispose() {
    fields().forEach((value) {
      _textEditingControllers[value.name]!.dispose();
    });
    super.dispose();
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

  List<Widget> formFields() {
    List<Widget> result = [];
    fields().forEach((value) {
      Widget? widget;
      if (value.isText()) {
        widget = TextFormField(
            controller: _textEditingControllers[value.name],
            decoration: InputDecoration(
              labelText: value.name.toCapitalCase(),
            ));
      }
      if (value.isBool()) {
        widget = SwitchListTile(
          title: Text(value.name.toCapitalCase()),
          value: _booleanState[value.name]!,
          activeColor: Colors.red,
          onChanged: (bool b) {
            // This is called when the user toggles the switch.
            setState(() {
              _booleanState[value.name] = b;
            });
          },
        );
      }
      if (value.isEnum()) {
        widget = DropdownButtonFormField<String?>(
            decoration: InputDecoration(
              labelText: value.name.toCapitalCase(),
            ),
            value:
                _enumState[value.name]! == '' ? null : _enumState[value.name]!,
            hint: const Text('Select an option'),
            onChanged: (String? enumValue) {
              setState(() {
                _enumState[value.name] = enumValue!;
              });
            },
            validator: (String? enumValue) {
              if (enumValue == null) {
                return 'Please select an option';
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
      }

      if (widget != null) {
        result.add(widget);
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText),
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
                  children: formFields(),
                  // const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     if (_formKey.currentState?.validate() ?? false) {
                  //       // Form is valid, process the data
                  //       _submitForm(ScaffoldMessenger.of(context));
                  //     }
                  //   },
                  //   child: const Text('Submit'),
                  // ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
