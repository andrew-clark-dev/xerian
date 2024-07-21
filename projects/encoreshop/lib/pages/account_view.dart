import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encoreshop/models/Account.dart';
import 'package:encoreshop/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_validation/form_validation.dart';

const readOnlyStyle = TextStyle(color: Colors.deepPurpleAccent);

class AccountView extends StatefulWidget {
  final Account? account;

  const AccountView({super.key, this.account});

  static String get path => "/${Account.schema.name.toLowerCase()}";

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  late final controllers = <String, TextEditingController>{};
  late final booleanStates = <String, bool>{};
  late final enumStates = <String, String?>{};

  late final Account? account;
  late final bool update;

  final NumberFormat formatter = NumberFormat("00000000");
//  final CounterService counter = CounterService(Account.classType);

  final emailValidator = Validator(validators: [const EmailValidator()]);
  final phoneValidator = Validator(validators: [const PhoneNumberValidator()]);
  final requiredValidator = Validator(validators: [const RequiredValidator()]);

  @override
  void initState() {
    super.initState();
    account = widget.account;
    update = account != null;

    // Default the states
    controllers[Account.NUMBER.fieldName] = TextEditingController();
    controllers[Account.FIRSTNAME.fieldName] = TextEditingController();
    controllers[Account.LASTNAME.fieldName] = TextEditingController();

    if (update) {
      controllers[Account.NUMBER.fieldName]!.text = account!.number;
      controllers[Account.FIRSTNAME.fieldName]!.text = account!.firstName;
      controllers[Account.LASTNAME.fieldName]!.text = account!.lastName ?? "";
    }
  }

  Future<void> submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    GraphQLRequest<Model> request;
    if (update) {
      final updatedAccount = account!.copyWith(
          firstName: controllers[Account.FIRSTNAME.fieldName]!.text, lastName: controllers[Account.FIRSTNAME.fieldName]!.text);
      request = ModelMutations.update(updatedAccount);
    } else {
      final newAccount = Account(
          number: "1",
          firstName: controllers[Account.FIRSTNAME.fieldName]!.text,
          lastName: controllers[Account.FIRSTNAME.fieldName]!.text);
      request = ModelMutations.create(newAccount);
    }

    final response = await Amplify.API.mutate(request: request).response;

    scaffoldMessenger.showSnackBar(SnackBar(content: Text('Account store ${response.hasErrors ? "failed" : "succeeded"}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageBar(Account.schema.name),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(
                    children: [
                      TextFormField(
                          controller: controllers[Account.NUMBER.fieldName],
                          decoration: const InputDecoration(labelText: 'Number'),
                          readOnly: true,
                          style: readOnlyStyle),
                      TextFormField(
                          controller: controllers[Account.FIRSTNAME.fieldName],
                          decoration: const InputDecoration(labelText: 'First Name')),
                      TextFormField(
                          controller: controllers[Account.LASTNAME.fieldName],
                          decoration: const InputDecoration(labelText: 'Last Name')),
                    ],
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

  // FormField formField(ModelField field) {
  //   switch (field.fieldType()) {
  //     case ModelFieldTypeEnum.bool:
  //       return switcher(field);
  //     case ModelFieldTypeEnum.enumeration:
  //       return dropDown(field);
  //     default:
  //       return text(field);
  //   }
  // }

  // TextFormField text(String labelText, {bool readOnly = false}) => TextFormField(
  //     controller: controllers[field.name],
  //     decoration: InputDecoration(
  //       labelText: config.viewFieldTitleName(field.name),
  //     ),
  //     readOnly: field.isAutoSet(),
  //     style: field.isAutoSet() ? const TextStyle(color: Colors.deepPurpleAccent) : null);

  // DropdownButtonFormField dropDown(ModelField field) => DropdownButtonFormField<String?>(
  //     decoration: InputDecoration(
  //       labelText: config.viewFieldTitleName(field.name),
  //     ),
  //     value: enumStates[field.name],
  //     hint: const Text('Select an option'),
  //     onChanged: (String? enumValue) {
  //       setState(() {
  //         enumStates[field.name] = enumValue!;
  //       });
  //     },
  //     validator: (String? enumValue) {
  //       if (enumValue == null) {
  //         return 'Please select a value';
  //       }
  //       return null;
  //     },
  //     items: config.enumValues(field.name).map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList());

  // FormField switcher(ModelField field) {
  //   return FormField(
  //       key: null,
  //       initialValue: false,
  //       builder: (FormFieldState<dynamic> fieldState) {
  //         return InputDecorator(
  //             decoration: InputDecoration(
  //               labelText: config.viewFieldTitleName(field.name),
  //             ),
  //             textAlign: TextAlign.left,
  //             child: Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Transform.scale(
  //                     scale: 0.8,
  //                     child: Switch(
  //                       // This bool value toggles the switch.
  //                       value: booleanStates[field.name]!,
  //                       onChanged: (bool b) {
  //                         setState(() {
  //                           booleanStates[field.name] = b;
  //                         });
  //                       },
  //                     ))));
  //       });
  // }
}
