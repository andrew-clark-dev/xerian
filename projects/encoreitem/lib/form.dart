import 'package:amplify_core/amplify_core.dart';
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

  final TextEditingController _accountController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controllers.forEach((key, controller) => controller.dispose());
    _accountController.dispose();
    super.dispose();
  }

  bool printOnSave = true;

  TextFormField textFormField(final String label, final String hint) {
    final textFormController = TextEditingController();
    controllers[label] = textFormController;
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: false,
        hintText: hint,
        labelText: label,
      ),
      controller: textFormController,
    );
  }

  FormField switchFormField(final String label) {
    return FormField(
        key: null,
        initialValue: false,
        builder: (FormFieldState<dynamic> fieldState) {
          return InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
              ),
              textAlign: TextAlign.left,
              child: Align(
                  alignment: Alignment.center,
                  child: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: printOnSave,
                        onChanged: (enabled) {
                          setState(() {
                            printOnSave = enabled;
                          });
                        },
                      ))));
        });
  }

  TypeAheadField typeAheadField<T extends Model>(
    callback,
    modelName,
  ) {
    controllers[modelName] = TextEditingController();
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
          title: Text(item.toMap()['name'] as String),
        );
      },
      onSelected: (T item) {
        controllers[modelName]!.text = item.toMap()['name'] as String;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 24,
                ),
                ...[
                  TypeAheadField<Account>(
                    controller: _accountController,
                    suggestionsCallback: (search) => DataStore().accountsByNumber(search),
                    builder: (context, controller, focusNode) {
                      return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          autofocus: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Account',
                          ));
                    },
                    itemBuilder: (context, account) {
                      return ListTile(
                        title: Text(account.num),
                        subtitle: Text(account.fullName),
                      );
                    },
                    onSelected: (Account account) {
                      _accountController.text = "${account.num} - ${account.fullName}";
                    },
                  ),
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
                      SizedBox(width: 100, child: switchFormField('Print On Save')),
                    ],
                  ),
                ].expand(
                  (widget) => [
                    widget,
                    const SizedBox(
                      height: 24,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension AccountExtensions on Account {
  String get fullName => "${firstName ?? ""} ${lastName ?? ""}";
  String get num => number.padLeft(8, '0');
}
