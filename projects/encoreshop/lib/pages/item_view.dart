import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encoreshop/models/ModelProvider.dart';
import 'package:encoreshop/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_validation/form_validation.dart';

const readOnlyStyle = TextStyle(color: Colors.deepPurpleAccent);

class ItemView extends StatefulWidget {
  final Item? item;

  const ItemView({super.key, this.item});

  static String get path => "/${Item.schema.name.toLowerCase()}";

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  late final controllers = <QueryField, TextEditingController>{};
  late final booleanStates = <QueryField, bool>{};
  late final enumStates = <QueryField, String>{};

  late final Item? item;
  late final bool update;

  final NumberFormat formatter = NumberFormat("00000000");
//  final CounterService counter = CounterService(Item.classType);

  final emailValidator = Validator(validators: [const EmailValidator()]);
  final phoneValidator = Validator(validators: [const PhoneNumberValidator()]);
  final requiredValidator = Validator(validators: [const RequiredValidator()]);

  @override
  void initState() {
    super.initState();
    item = widget.item;
    update = item != null;

    // Default the states
    controllers[Item.SKU] = TextEditingController();
    controllers[Item.TITLE] = TextEditingController();
    controllers[Item.ACCOUNTNUMBER] = TextEditingController();
    controllers[Item.CATEGORY] = TextEditingController();
    controllers[Item.PRICE] = TextEditingController();
    controllers[Item.BRAND] = TextEditingController();
    controllers[Item.COLOR] = TextEditingController();
    controllers[Item.SIZE] = TextEditingController();
    controllers[Item.DESCRIPTION] = TextEditingController();
    controllers[Item.DETAILS] = TextEditingController();
    controllers[Item.QUANTITY] = TextEditingController();
    booleanStates[Item.ACTIVE] = true;
    enumStates[Item.STATUS] = ItemStatus.tagged.name;
    enumStates[Item.CONDITION] = ItemCondition.unknown.name;

    if (update) {
      controllers[Item.SKU]!.text = formatter.format(item!.sku);
      controllers[Item.TITLE]!.text = item!.title ?? "";
      controllers[Item.ACCOUNTNUMBER]!.text = formatter.format(item!.accountNumber);
      controllers[Item.CATEGORY]!.text = item!.category;
      controllers[Item.PRICE]!.text = item!.price.toStringAsFixed(2);
      controllers[Item.BRAND]!.text = item!.brand ?? "";
      controllers[Item.COLOR]!.text = item!.color ?? "";
      controllers[Item.SIZE]!.text = item!.size ?? "";
      controllers[Item.DESCRIPTION]!.text = item!.description ?? "";
      controllers[Item.DETAILS]!.text = item!.details ?? "";
      controllers[Item.QUANTITY]!.text = item!.quantity.toString();
      booleanStates[Item.ACTIVE] = item!.active ?? false;
      // enumStates[Item.STATUS] = item!.status!.name;
      enumStates[Item.CONDITION] = item!.condition!.name;
    }
  }

  Future<void> submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    // GraphQLRequest<Model> request;
    // if (update) {
    //   final updatedItem = item!.copyWith(firstName: controllers[Item.FIRSTNAME]!.text, lastName: controllers[Item.FIRSTNAME]!.text);
    //   request = ModelMutations.update(updatedItem);
    // } else {
    //   final newItem = Item(
    //       number: 1, firstName: controllers[Item.FIRSTNAME]!.text, lastName: controllers[Item.FIRSTNAME]!.text, balance: 10.00);
    //   request = ModelMutations.create(newItem);
    // }

    // final response = await Amplify.API.mutate(request: request).response;

    // scaffoldMessenger.showSnackBar(SnackBar(content: Text('Item store ${response.hasErrors ? "failed" : "succeeded"}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageBar(Item.schema.name),
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
                      text(Item.SKU, 'SKU', readOnly: true),
                      text(Item.TITLE, 'Title', readOnly: true),
                      text(Item.ACCOUNTNUMBER, 'Account', readOnly: true),
                      Row(children: [
                        Expanded(child: text(Item.CATEGORY, 'Category')),
                        Expanded(child: text(Item.BRAND, 'Brand')),
                      ]),
                      Row(children: [
                        Expanded(child: text(Item.COLOR, 'Color')),
                        Expanded(child: text(Item.SIZE, 'Size')),
                      ]),
                      switcher(Item.ACTIVE, 'Active'),
                      dropDown(Item.STATUS, 'Status', ItemStatus.values),
                      dropDown(Item.CONDITION, 'Contition', ItemCondition.values),
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
