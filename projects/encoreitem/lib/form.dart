import 'package:barcode_widget/barcode_widget.dart';

import 'package:amplify_core/amplify_core.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:encoreitem/models/Account.dart';
import 'package:encoreitem/models/Brand.dart';
import 'package:encoreitem/models/Category.dart' as c;
import 'package:encoreitem/models/Color.dart';
import 'package:encoreitem/models/Size.dart';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'services/data_store.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  @override
  State<StatefulWidget> createState() => _ItemFormState();
}

class _ItemFormState extends State<StatefulWidget> {
  final _formKey = GlobalKey<FormState>();

  final controllers = <String, TextEditingController>{};

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool printOnSave = true;

  TextFormField textFormField(final String modelName, final String hint) {
    controllers[modelName] = TextEditingController();
    controllers["${modelName}tag"] = TextEditingController();
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: false,
        hintText: hint,
        labelText: modelName,
      ),
      inputFormatters: [CurrencyTextInputFormatter.currency(locale: 'de_CH')],
      // controller: controllers[modelName],
      onChanged: (text) {
        controllers["${modelName}tag"]!.text = text;
      },
    );
  }

  TextFormField tagFormField(final String modelName, final double fontSize) {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: false,
        hintText: modelName,
        // contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      style: TextStyle(
        fontSize: fontSize, // Set the text size here
        color: Colors.black, // Optionally set the text color
      ),
      readOnly: true,
      textAlign: TextAlign.center,
      controller: controllers["${modelName}tag"],
    );
  }

  TypeAheadField typeAheadField<T extends Model>(
    callback,
    modelName,
  ) {
    return customTypeAheadField<T>(callback, modelName, (v) => nameValue(v), (v) => nameValue(v));
  }

  TypeAheadField customTypeAheadField<T extends Model>(
    callback,
    modelName,
    Function formValue,
    Function tagValue,
  ) {
    controllers[modelName] = TextEditingController();
    controllers["${modelName}tag"] = TextEditingController();
    return TypeAheadField<T>(
      controller: controllers[modelName],
      suggestionsCallback: callback,
      builder: (context, controller, focusNode) {
        return TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: modelName,
            ));
      },
      itemBuilder: (context, item) {
        return ListTile(
          title: Text(formValue(item)),
        );
      },
      onSelected: (T item) {
        controllers[modelName]!.text = formValue(item);
        controllers["${modelName}tag"]!.text = tagValue(item);
      },
    );
  }

  String accountFormValue(Account account) => "${account.num} - ${account.fullName}";
  String accountTagValue(Account account) => account.num;

  String nameValue(Model model) => model.toMap()['name'] as String;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Item'),
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350, maxHeight: 900),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      ...[
                        customTypeAheadField<Account>((search) => DataStore().accountsByNumber(search), 'Account',
                            (account) => accountFormValue(account), (account) => accountTagValue(account)),
                        typeAheadField<c.Category>((search) => DataStore().categoriesByName(search), 'Category'),
                        typeAheadField<Brand>((search) => DataStore().brandsByName(search), 'Brand'),
                        typeAheadField<Color>((search) => DataStore().colorsByName(search), 'Color'),
                        typeAheadField<Size>((search) => DataStore().sizesByName(search), 'Size'),
                        textFormField('Description', 'Enter the item description'),
                        textFormField('Price', 'Enter the item tag price'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Processing Data')),
                                  );
                                }
                              },
                              child: const Text('Save'),
                            ),
                            const Spacer(),
                            const Text("Print on Save "),
                            Switch(
                              value: printOnSave,
                              onChanged: (enabled) {
                                setState(() {
                                  printOnSave = enabled;
                                });
                              },
                            )
                          ],
                        ),
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 320.0 / 2,
                        height: 580.0 / 2,
                        child: Card(
                            child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Icon(Icons.emoji_nature_rounded, size: 40),
                            const SizedBox(height: 16),
                            tagFormField('Account', 20),
                            tagFormField('Brand', 16),
                            tagFormField('Size', 16),
                            const Text('Details'),
                            tagFormField('Price', 25),
                            const SizedBox(height: 10),
                            BarcodeWidget(
                              barcode: Barcode.code39(), // Barcode type and settings
                              data: '123456789', // Content
                              width: 150,
                              height: 70,
                            ),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

extension AccountExtensions on Account {
  String get fullName => "${firstName ?? ""} ${lastName ?? ""}";
  String get num => number.padLeft(8, '0');
}
