import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encoreshop/models/ModelProvider.dart';
import 'package:encoreshop/pages/pages.dart';
import 'package:flutter/material.dart';

import 'page_view_state.dart';

const readOnlyStyle = TextStyle(color: Colors.deepPurpleAccent);

class ColorView extends StatefulWidget {
  final Color? color;

  const ColorView({super.key, this.color});

  static String get path => "/${Color.schema.name.toLowerCase()}";

  @override
  State<ColorView> createState() => _ColorViewState();
}

class _ColorViewState extends PageViewState<ColorView> {
  late final Color? color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    update = color != null;

    // Default the states
    controllers[Color.NAME] = TextEditingController();
    controllers[Color.ALT] = TextEditingController();
    booleanStates[Color.ACTIVE] = false;

    if (update) {
      controllers[Color.NAME]!.text = color!.name;
      controllers[Color.ALT]!.text = color!.alt?.join(', ') ?? "";
      booleanStates[Color.ACTIVE] = color!.active ?? false;
    }
  }

  Future<void> submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    GraphQLRequest<Model> request;
    if (update) {
      final updatedColor = color!.copyWith(active: booleanStates[Color.ACTIVE], alt: controllers[Color.ALT]!.text.split(', '));
      request = ModelMutations.update(updatedColor);
    } else {
      final newColor = Color(
          name: controllers[Color.NAME]!.text, active: booleanStates[Color.ACTIVE], alt: controllers[Color.ALT]!.text.split(', '));
      request = ModelMutations.create(newColor);
    }

    final response = await Amplify.API.mutate(request: request).response;

    scaffoldMessenger.showSnackBar(SnackBar(content: Text('Color store ${response.hasErrors ? "failed" : "succeeded"}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageBar(Color.schema.name),
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
                      text(Color.NAME, 'Name', readOnly: true),
                      text(Color.ALT, 'ALternatives'),
                      switcher(Color.ACTIVE, 'Active'),
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
