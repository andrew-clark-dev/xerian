import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encore_core/src/model_ui/config/model_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_validation/form_validation.dart';

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

  late final ModelType modelType;
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
    modelType = widget.modelType;
    for (var field in modelType.viewModelFields) {
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
      for (var field in modelType.viewModelFields) {
        switch (field.fieldType()) {
          case ModelFieldTypeEnum.bool:
            booleanStates[field.name] = (json[field.name] ?? false) as bool;
          case ModelFieldTypeEnum.enumeration:
            enumStates[field.name] = json[field.name] == null
                ? null
                : (json[field.name] as Enum).name;
          case ModelFieldTypeEnum.double:
            controllers[field.name]!.text =
                json[field.name]?.toString() ?? '0.0';
          case ModelFieldTypeEnum.dateTime:
            controllers[field.name]!.text = json[field.name]?.toString() ?? '';
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
    for (var field in modelType.viewModelFields) {
      switch (field.fieldType()) {
        case ModelFieldTypeEnum.bool:
          jsonData[field.name] = booleanStates[field.name];
        case ModelFieldTypeEnum.enumeration:
          jsonData[field.name] = enumStates[field.name];
        case ModelFieldTypeEnum.double:
          jsonData[field.name] =
              double.parse(controllers[field.name]?.value.text ?? '0.0');
        // case ModelFieldTypeEnum.dateTime:
        //   jsonData[field.name] = dateFormatter
        //       .parse(controllers[field.name]?.value.text ?? '')
        //       .toIso8601String();
        default:
          jsonData[field.name] = controllers[field.name]?.value.text;
      }
    }

    GraphQLRequest<Model> request;
    if (update) {
      request = ModelMutations.update(modelType.fromJson(jsonData));
    } else {
      jsonData['id'] = UUID.getUUID();
      request = ModelMutations.create(modelType.fromJson(jsonData));
    }

    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(' ${modelType.modelName} store failed'),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('${modelType.modelName} stored successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        children: modelType.viewModelFields
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
        labelText: modelType.uiConfig.viewFieldTitleName(field.name),
      ),
      readOnly: field.isAutoSet(),
      style: field.isAutoSet()
          ? const TextStyle(color: Colors.deepPurpleAccent)
          : null);

  DropdownButtonFormField dropDown(ModelField field) =>
      DropdownButtonFormField<String?>(
          decoration: InputDecoration(
            labelText: modelType.uiConfig.viewFieldTitleName(field.name),
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
          items: modelType.uiConfig
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
                labelText: modelType.uiConfig.viewFieldTitleName(field.name),
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
