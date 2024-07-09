import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:change_case/change_case.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_validation/form_validation.dart';
import 'package:xerian/extensions/model_extensions.dart';
import 'package:xerian/widgets/model_app_bar.dart';
import 'package:xerian/widgets/model_ui_config.dart';

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
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  late final _controllers = <String, TextEditingController>{};
  late final _booleanState = <String, bool>{};
  late final _enumState = <String, String?>{};

  late final ModelUiConfig config;
  late final Model? model;
  String _titleText = 'Create ';
  final NumberFormat formatter = NumberFormat("00000000");
//  final CounterService counter = CounterService(Account.classType);

  final emailValidator = Validator(validators: [const EmailValidator()]);
  final phoneValidator = Validator(validators: [const PhoneNumberValidator()]);
  final requiredValidator = Validator(validators: [const RequiredValidator()]);

  @override
  void initState() {
    super.initState();
    model = widget.model;
    config = ModelUiConfig.config(widget.modelType);
    for (var field in config.viewModelFields) {
      switch (field.fieldType()) {
        case ModelFieldTypeEnum.bool:
          _booleanState[field.name] = false;
        case ModelFieldTypeEnum.enumeration:
          _enumState[field.name] = null;
        default:
          _controllers[field.name] = TextEditingController();
      }
    }

    if (model != null) {
      _titleText = 'Update ';
      final json = model!.toMap();
      for (var field in config.viewModelFields) {
        switch (field.fieldType()) {
          case ModelFieldTypeEnum.bool:
            _booleanState[field.name] = (json[field.name] ?? false) as bool;
          case ModelFieldTypeEnum.enumeration:
            _enumState[field.name] = json[field.name] == null
                ? null
                : (json[field.name] as Enum).name;
          // case ModelFieldTypeEnum.double:
          //   _controllers[field.name]!.text =
          //       (json[field.name] ?? '0.00') as String;
          case ModelFieldTypeEnum.dateTime:
            _controllers[field.name]!.text = dateFormatter.format(
                (json[field.name] as TemporalDateTime).getDateTimeInUtc());
          default:
            _controllers[field.name]!.text =
                json[field.name]?.toString() ?? 'None';
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
      appBar: ModelAppBar(config.modelType),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: config.viewModelFields
                            .map((f) => formField(f))
                            .toList(),
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

  TextFormField text(ModelField field) => TextFormField(
      controller: _controllers[field.name],
      decoration: InputDecoration(
        labelText: field.name.toCapitalCase(),
      ),
      readOnly: field.isAutoSet(),
      style: field.isAutoSet()
          ? const TextStyle(color: Colors.deepPurpleAccent)
          : null);

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
          items: config
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
                  child: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        // This bool value toggles the switch.
                        value: _booleanState[value.name]!,
                        onChanged: (bool b) {
                          setState(() {
                            _booleanState[value.name] = b;
                          });
                        },
                      ))));
        });
  }
}
