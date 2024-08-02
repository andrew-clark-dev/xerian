import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<StatefulWidget> {
  final _formKey = GlobalKey<FormState>();
  var controllers = <String, TextEditingController>{};
  final itemScrollController = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  String account = '';
  String description = '';
  DateTime date = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;

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
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.vertical,
                controller: itemScrollController,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        textFormField('Account', 'Enter the members account number'),
                        textFormField('Category', 'Enter the item category'),
                        textFormField('Description', 'Enter the item description'),
                        textFormField('Brand', 'Enter the item brand'),
                        textFormField('Color', 'Enter the item color'),
                        textFormField('Size', 'Enter the item size'),
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
        ),
      ),
    );
  }
}
