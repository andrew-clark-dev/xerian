import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encoreshop/models/ModelProvider.dart';
import 'package:encoreshop/pages/pages.dart';
import 'package:flutter/material.dart';

import 'page_view_state.dart';

const readOnlyStyle = TextStyle(color: Colors.deepPurpleAccent);

class SizeView extends StatefulWidget {
  final Size? size;

  const SizeView({super.key, this.size});

  static String get path => "/${Size.schema.name.toLowerCase()}";

  @override
  State<SizeView> createState() => _SizeViewState();
}

class _SizeViewState extends PageViewState<SizeView> {
  late final Size? size;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    update = size != null;

    // Default the states
    controllers[Size.NAME] = TextEditingController();
    controllers[Size.ALT] = TextEditingController();
    booleanStates[Size.ACTIVE] = false;

    if (update) {
      controllers[Size.NAME]!.text = size!.name;
      controllers[Size.ALT]!.text = size!.alt?.join(', ') ?? "";
      booleanStates[Size.ACTIVE] = size!.active ?? false;
    }
  }

  Future<void> submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    GraphQLRequest<Model> request;
    if (update) {
      final updatedSize = size!.copyWith(active: booleanStates[Size.ACTIVE], alt: controllers[Size.ALT]!.text.split(', '));
      request = ModelMutations.update(updatedSize);
    } else {
      final newSize = Size(
          name: controllers[Size.NAME]!.text, active: booleanStates[Size.ACTIVE], alt: controllers[Size.ALT]!.text.split(', '));
      request = ModelMutations.create(newSize);
    }

    final response = await Amplify.API.mutate(request: request).response;

    scaffoldMessenger.showSnackBar(SnackBar(content: Text('Size store ${response.hasErrors ? "failed" : "succeeded"}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageBar(Size.schema.name),
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
                      text(Size.NAME, 'Name', readOnly: true),
                      text(Size.ALT, 'ALternatives'),
                      switcher(Size.ACTIVE, 'Active'),
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
