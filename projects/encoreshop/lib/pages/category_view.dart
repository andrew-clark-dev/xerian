import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/Category.dart' as m;
import 'package:encoreshop/pages/pages.dart';
import 'package:flutter/material.dart';

import 'page_view_state.dart';

const readOnlyStyle = TextStyle(color: Colors.deepPurpleAccent);

class CategoryView extends StatefulWidget {
  final m.Category? brand;

  const CategoryView({super.key, this.brand});

  static String get path => "/${m.Category.schema.name.toLowerCase()}";

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends PageViewState<CategoryView> {
  late final m.Category? brand;

  @override
  void initState() {
    super.initState();
    brand = widget.brand;
    update = brand != null;

    // Default the states
    controllers[m.Category.NAME] = TextEditingController();
    controllers[m.Category.ALT] = TextEditingController();
    booleanStates[m.Category.ACTIVE] = false;

    if (update) {
      controllers[m.Category.NAME]!.text = brand!.name;
      controllers[m.Category.ALT]!.text = brand!.alt?.join(', ') ?? "";
      booleanStates[m.Category.ACTIVE] = brand!.active ?? false;
    }
  }

  Future<void> submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    GraphQLRequest<Model> request;
    if (update) {
      final updatedCategory =
          brand!.copyWith(active: booleanStates[m.Category.ACTIVE], alt: controllers[m.Category.ALT]!.text.split(', '));
      request = ModelMutations.update(updatedCategory);
    } else {
      final newCategory = m.Category(
          name: controllers[m.Category.NAME]!.text,
          active: booleanStates[m.Category.ACTIVE],
          alt: controllers[m.Category.ALT]!.text.split(', '));
      request = ModelMutations.create(newCategory);
    }

    final response = await Amplify.API.mutate(request: request).response;

    scaffoldMessenger.showSnackBar(SnackBar(content: Text('m.Category store ${response.hasErrors ? "failed" : "succeeded"}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageBar(m.Category.schema.name),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(
                    children: [
                      text(m.Category.NAME, 'Name', readOnly: true),
                      text(m.Category.ALT, 'ALternatives'),
                      switcher(m.Category.ACTIVE, 'Active'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
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
}
