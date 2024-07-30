import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encoreshop/models/ModelProvider.dart';
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

  late final controllers = <QueryField, TextEditingController>{};
  late final booleanStates = <QueryField, bool>{};
  late final enumStates = <QueryField, String>{};

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
    controllers[Account.NUMBER] = TextEditingController();
    controllers[Account.FIRSTNAME] = TextEditingController();
    controllers[Account.LASTNAME] = TextEditingController();
    controllers[Account.ADDRESS] = TextEditingController();
    controllers[Account.BALANCE] = TextEditingController();
    controllers[Account.CITY] = TextEditingController();
    controllers[Account.COMMENT] = TextEditingController();
    controllers[Account.EMAIL] = TextEditingController();
    controllers[Account.PHONENUMBER] = TextEditingController();
    controllers[Account.POSTCODE] = TextEditingController();
    controllers[Account.STATE] = TextEditingController();
    booleanStates[Account.ISMOBILE] = false;
    booleanStates[Account.VIP] = false;
    enumStates[Account.STATUS] = AccountStatus.active.name;
    enumStates[Account.COMUNICATIONPREFERENCES] = AccountComunicationPreferences.none.name;

    if (update) {
      controllers[Account.NUMBER]!.text = formatter.format(account!.number);
      controllers[Account.FIRSTNAME]!.text = account!.firstName ?? "";
      controllers[Account.LASTNAME]!.text = account!.lastName ?? "";
      controllers[Account.ADDRESS]!.text = account!.address ?? "";
      controllers[Account.BALANCE]!.text = account!.balance.toStringAsFixed(2);
      controllers[Account.CITY]!.text = account!.city ?? "";
      controllers[Account.COMMENT]!.text = account!.comment ?? "";
      controllers[Account.EMAIL]!.text = account!.email ?? "";
      controllers[Account.PHONENUMBER]!.text = account!.phoneNumber ?? "";
      controllers[Account.POSTCODE]!.text = account!.postcode ?? "";
      controllers[Account.STATE]!.text = account!.state ?? "";
      booleanStates[Account.ISMOBILE] = account!.isMobile ?? false;
      booleanStates[Account.VIP] = account!.vip == AccountVip.vip;

      enumStates[Account.STATUS] = account!.status!.name;
      enumStates[Account.COMUNICATIONPREFERENCES] = account!.comunicationPreferences!.name;
    }
  }

  Future<void> submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    GraphQLRequest<Model> request;
    if (update) {
      final updatedAccount =
          account!.copyWith(firstName: controllers[Account.FIRSTNAME]!.text, lastName: controllers[Account.FIRSTNAME]!.text);
      request = ModelMutations.update(updatedAccount);
    } else {
      final newAccount = Account(
          number: 1,
          firstName: controllers[Account.FIRSTNAME]!.text,
          lastName: controllers[Account.FIRSTNAME]!.text,
          balance: 10.00);
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
                      text(Account.NUMBER, 'Number', readOnly: true),
                      Row(children: [
                        Expanded(child: text(Account.FIRSTNAME, 'First Name')),
                        Expanded(child: text(Account.LASTNAME, 'Last Name')),
                      ]),
                      Row(children: [
                        Expanded(child: text(Account.PHONENUMBER, 'Phone Number')),
                        Expanded(child: text(Account.EMAIL, 'E-Mail')),
                      ]),
                      text(Account.ADDRESS, 'Address'),
                      Row(children: [
                        Expanded(child: text(Account.CITY, 'City')),
                        Expanded(child: text(Account.POSTCODE, 'Postcode')),
                      ]),
                      text(Account.STATE, 'State'),
                      text(Account.BALANCE, 'Balance', readOnly: true),
                      switcher(Account.ISMOBILE, 'Mobile'),
                      switcher(Account.VIP, 'VIP'),
                      dropDown(Account.STATUS, 'Status', AccountStatus.values.map((v) => v.name).toList()),
                      dropDown(Account.COMUNICATIONPREFERENCES, 'Prefs',
                          AccountComunicationPreferences.values.map((v) => v.name).toList()),
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

  TextFormField text(QueryField field, String labelText, {bool readOnly = false}) => TextFormField(
      controller: controllers[field],
      decoration: InputDecoration(
        labelText: labelText,
      ),
      readOnly: readOnly,
      style: readOnly ? readOnlyStyle : null);

  DropdownButtonFormField dropDown(QueryField field, String labelText, List<String> enumValues) => DropdownButtonFormField<String?>(
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
      items: enumValues.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList());

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
