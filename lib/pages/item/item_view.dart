import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:xerian/models/Item.dart';
import 'package:xerian/services/counter_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_validation/form_validation.dart';

import '../routable.dart';

class ItemView extends StatefulWidget implements RoutableExtra {
  final Item? item;
  const ItemView({
    super.key,
    this.item,
  });

  @override
  String get path => '/item';

  @override
  void extra(Object extra) => ItemView(item: extra as Item);

  @override
  State<ItemView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemView> {
  final _formKey = GlobalKey<FormState>();

  final NumberFormat formatter = NumberFormat("00000000");
  final CounterService counter = CounterService(Item.classType);

  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final requiredValidator = Validator(validators: [const RequiredValidator()]);

  late final String _titleText;

  @override
  void initState() {
    super.initState();

    var item = widget.item;

    if (item != null) {
      _skuController.text = formatter.format(item.sku);
      _descriptionController.text = item.description;
      _titleText = 'Update item';
    } else {
      _titleText = 'Create item';
    }
  }

  @override
  void dispose() {
    _skuController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    // If the form is valid, submit the data

    // if (_isCreate) {
    // Create a new item entry
    final newItem = Item(
      sku: await counter.next(),
      description: _descriptionController.text,
    );

    final request = ModelMutations.create(newItem);

    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Item details store failed'),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Item ${newItem.sku} details stored successfully'),
        ),
      );
    }

    // } else {
    //   // Update item instead
    //   final updateItem = _item!.copyWith(
    //     firstName: firstName,
    //     lastName: lastName.isNotEmpty ? lastName : null,
    //   );
    //   await repo.put(updateItem);
    // }
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
                  children: [
                    TextFormField(
                      enabled: false,
                      controller: _skuController,
                      decoration: const InputDecoration(
                        labelText: 'SKU',
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        return requiredValidator.validate(
                            label: 'Description', value: value);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Form is valid, process the data
                          _submitForm(ScaffoldMessenger.of(context));
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
