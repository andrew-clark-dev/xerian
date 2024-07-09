import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:change_case/change_case.dart';
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

  @protected
  late final controllers = <String, TextEditingController>{};
  @protected
  late final booleanStates = <String, bool>{};
  @protected
  late final enumStates = <String, String?>{};

  late final ModelUiConfig config;
  late final Model? model;
  late final bool update;

  final NumberFormat formatter = NumberFormat("00000000");
//  final CounterService counter = CounterService(Account.classType);

  final emailValidator = Validator(validators: [const EmailValidator()]);
  final phoneValidator = Validator(validators: [const PhoneNumberValidator()]);
  final requiredValidator = Validator(validators: [const RequiredValidator()]);

  @override
  void initState() {
    super.initState();
    model = widget.model;
    update = model != null;
    config = ModelUiConfig.config(widget.modelType);
    for (var field in config.viewModelFields) {
      switch (field.fieldType()) {
        case ModelFieldTypeEnum.bool:
          booleanStates[field.name] = false;
        case ModelFieldTypeEnum.enumeration:
          enumStates[field.name] = null;
        default:
          controllers[field.name] = TextEditingController();
      }
    }

    if (update) {
      final json = model!.toMap();
      for (var field in config.viewModelFields) {
        switch (field.fieldType()) {
          case ModelFieldTypeEnum.bool:
            booleanStates[field.name] = (json[field.name] ?? false) as bool;
          case ModelFieldTypeEnum.enumeration:
            enumStates[field.name] = json[field.name] == null
                ? null
                : (json[field.name] as Enum).name;
          // case ModelFieldTypeEnum.double:
          //   controllers[field.name]!.text =
          //       (json[field.name] ?? '0.00') as String;
          case ModelFieldTypeEnum.dateTime:
            controllers[field.name]!.text = dateFormatter.format(
                (json[field.name] as TemporalDateTime).getDateTimeInUtc());
          default:
            controllers[field.name]!.text =
                json[field.name]?.toString() ?? 'None';
        }
      }
    }
  }

  Future<void> submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    Map<String, Object?> jsonData = {};

    // For updates initialize to the existing model
    if (update) jsonData = model!.toJson();

    // Update all displayed fields (Note: required fields not displayed must be defaulted, obviously)
    for (var field in config.viewModelFields) {
      switch (field.fieldType()) {
        case ModelFieldTypeEnum.bool:
          jsonData[field.name] = booleanStates[field.name].toString();
        case ModelFieldTypeEnum.enumeration:
          jsonData[field.name] = enumStates[field.name];
        default:
          jsonData[field.name] = controllers[field.name]?.value.text ?? "";
      }
    }

    GraphQLRequest<Model> request;
    if (update) {
      request = ModelMutations.update(config.modelType.fromJson(jsonData));
    } else {
      request = ModelMutations.create(config.modelType.fromJson(jsonData));
    }

    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(' ${config.modelName} store failed'),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('${config.modelName} stored successfully'),
        ),
      );
    }
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
                            submitForm(ScaffoldMessenger.of(context));
                          }
                        },
                        child: Text(update ? 'Update' : 'Create'),
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
      controller: controllers[field.name],
      decoration: InputDecoration(
        labelText: config.viewFieldTitleName(field.name),
      ),
      readOnly: field.isAutoSet(),
      style: field.isAutoSet()
          ? const TextStyle(color: Colors.deepPurpleAccent)
          : null);

  DropdownButtonFormField dropDown(ModelField field) =>
      DropdownButtonFormField<String?>(
          decoration: InputDecoration(
            labelText: config.viewFieldTitleName(field.name),
          ),
          value: enumStates[field.name],
          hint: const Text('Select an option'),
          onChanged: (String? enumValue) {
            setState(() {
              enumStates[field.name] = enumValue!;
            });
          },
          validator: (String? enumValue) {
            if (enumValue == null) {
              return 'Please select a value';
            }
            return null;
          },
          items: config
              .enumValues(field.name)
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList());

  FormField switcher(ModelField field) {
    return FormField(
        key: null,
        initialValue: false,
        builder: (FormFieldState<dynamic> fieldState) {
          return InputDecorator(
              decoration: InputDecoration(
                labelText: config.viewFieldTitleName(field.name),
              ),
              textAlign: TextAlign.left,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        // This bool value toggles the switch.
                        value: booleanStates[field.name]!,
                        onChanged: (bool b) {
                          setState(() {
                            booleanStates[field.name] = b;
                          });
                        },
                      ))));
        });
  }
}
