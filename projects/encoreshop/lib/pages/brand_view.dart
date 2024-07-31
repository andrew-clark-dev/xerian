import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encoreshop/models/ModelProvider.dart';
import 'package:encoreshop/pages/pages.dart';
import 'package:flutter/material.dart';

import 'page_view_state.dart';

const readOnlyStyle = TextStyle(color: Colors.deepPurpleAccent);

class BrandView extends StatefulWidget {
  final Brand? brand;

  const BrandView({super.key, this.brand});

  static String get path => "/${Brand.schema.name.toLowerCase()}";

  @override
  State<BrandView> createState() => _BrandViewState();
}

class _BrandViewState extends PageViewState<BrandView> {
  late final Brand? brand;

  @override
  void initState() {
    super.initState();
    brand = widget.brand;
    update = brand != null;

    // Default the states
    controllers[Brand.NAME] = TextEditingController();
    controllers[Brand.ALT] = TextEditingController();
    booleanStates[Brand.ACTIVE] = false;

    if (update) {
      controllers[Brand.NAME]!.text = brand!.name;
      controllers[Brand.ALT]!.text = brand!.alt?.join(', ') ?? "";
      booleanStates[Brand.ACTIVE] = brand!.active ?? false;
    }
  }

  Future<void> submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    GraphQLRequest<Model> request;
    if (update) {
      final updatedBrand = brand!.copyWith(active: booleanStates[Brand.ACTIVE], alt: controllers[Brand.ALT]!.text.split(', '));
      request = ModelMutations.update(updatedBrand);
    } else {
      final newBrand = Brand(
          name: controllers[Brand.NAME]!.text, active: booleanStates[Brand.ACTIVE], alt: controllers[Brand.ALT]!.text.split(', '));
      request = ModelMutations.create(newBrand);
    }

    final response = await Amplify.API.mutate(request: request).response;

    scaffoldMessenger.showSnackBar(SnackBar(content: Text('Brand store ${response.hasErrors ? "failed" : "succeeded"}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageBar(Brand.schema.name),
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
                      text(Brand.NAME, 'Name', readOnly: true),
                      text(Brand.ALT, 'ALternatives'),
                      switcher(Brand.ACTIVE, 'Active'),
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
