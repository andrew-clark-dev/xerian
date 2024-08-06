import 'package:encoreitem/models/Account.dart';
import 'package:encoreitem/models/Brand.dart';
import 'package:encoreitem/models/Category.dart';
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
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  final itemScrollController = ScrollController();

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
          child: Card(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                          title: Text(account.number.padLeft(8, '0')),
                          subtitle: Text(account.firstName ?? "None"),
                        );
                      },
                      onSelected: (Account account) {
                        _accountController.text = account.number.padLeft(8, '0');
                      },
                    ),
                    TypeAheadField<Category>(
                      controller: _categoryController,
                      suggestionsCallback: (search) => DataStore().categoriesByName(search),
                      builder: (context, controller, focusNode) {
                        return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Category',
                            ));
                      },
                      itemBuilder: (context, item) {
                        return ListTile(
                          title: Text(item.name),
                        );
                      },
                      onSelected: (Category item) {
                        _categoryController.text = item.name;
                      },
                    ),
                    TypeAheadField<Brand>(
                      controller: _brandController,
                      suggestionsCallback: (search) => DataStore().brandsByName(search),
                      builder: (context, controller, focusNode) {
                        return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Brand',
                            ));
                      },
                      itemBuilder: (context, item) {
                        return ListTile(
                          title: Text(item.name),
                        );
                      },
                      onSelected: (Brand item) {
                        _brandController.text = item.name;
                      },
                    ),
                    TypeAheadField<Color>(
                      controller: _colorController,
                      suggestionsCallback: (search) => DataStore().colorsByName(search),
                      builder: (context, controller, focusNode) {
                        return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Color',
                            ));
                      },
                      itemBuilder: (context, item) {
                        return ListTile(
                          title: Text(item.name),
                        );
                      },
                      onSelected: (Color item) {
                        _colorController.text = item.name;
                      },
                    ),
                    TypeAheadField<Size>(
                      controller: _sizeController,
                      suggestionsCallback: (search) => DataStore().sizesByName(search),
                      builder: (context, controller, focusNode) {
                        return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Size',
                            ));
                      },
                      itemBuilder: (context, item) {
                        return ListTile(
                          title: Text(item.name),
                        );
                      },
                      onSelected: (Size item) {
                        _sizeController.text = item.name;
                      },
                    ),
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
      ),
    );
  }
}
