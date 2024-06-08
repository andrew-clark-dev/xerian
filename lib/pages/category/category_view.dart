import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:xerian/models/Category.dart' as models;
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/pages/routable.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';

class CategoryView extends StatefulWidget implements RoutableExtra {
  final models.Category? category;
  const CategoryView({
    super.key,
    this.category,
  });

  @override
  String get path => '/category';

  @override
  extra(Object extra) => CategoryView(category: extra as models.Category);

  @override
  State<CategoryView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _alternativesController = TextEditingController();

  final requiredValidator = Validator(validators: [const RequiredValidator()]);
  final stringListValidator =
      Validator(validators: [const StringListValidator()]);

  late final String _titleText;

  @override
  void initState() {
    super.initState();

    var category = widget.category;

    if (category != null) {
      _typeController.text = category.type!.name;
      _valueController.text = category.value;
      _alternativesController.text = category.alternatives?.join(' ') ?? '';

      _titleText = 'Update Category';
    } else {
      _titleText = 'Create Category';
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    // If the form is valid, submit the data
    final type = CategoryType.values.byName(_typeController.text);

    final value = _valueController.text;
    // Compress all white space just incase the user put in a few extra spaces
    final alternatives = _alternativesController.text
        .trim()
        .replaceAll(RegExp(' +'), ' ')
        .split(' ');

    // if (_isCreate) {
    // Create a new Category entry
    final newCategory =
        models.Category(type: type, value: value, alternatives: alternatives);

    final request = ModelMutations.create(newCategory);

    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Category details store failed'),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content:
              Text('Category ${newCategory.value} details stored successfully'),
        ),
      );
    }

    // } else {
    //   // Update Category instead
    //   final updateCategory = _Category!.copyWith(
    //     firstName: firstName,
    //     lastName: lastName.isNotEmpty ? lastName : null,
    //   );
    //   await repo.put(updateCategory);
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
                    DropdownMenu(
                        controller: _typeController,
                        dropdownMenuEntries: CategoryType.values
                            .map((e) => DropdownMenuEntry<CategoryType>(
                                value: e, label: e.name))
                            .toList(),
                        initialSelection: CategoryType.department),
                    TextFormField(
                      controller: _valueController,
                      decoration: const InputDecoration(
                        labelText: 'Value',
                      ),
                      validator: (value) {
                        return requiredValidator.validate(
                            label: 'Value', value: value);
                      },
                    ),
                    TextFormField(
                      controller: _alternativesController,
                      decoration:
                          const InputDecoration(labelText: 'Alternatives'),
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

class StringListValidator implements ValueValidator {
  const StringListValidator();

  static const kType = 'stringlist';

  /// Returns the JSON-compatible representation of this validator.
  @override
  Map<String, dynamic> toJson() => {
        'type': type,
      };

  @override
  String get type => kType;

  @override
  String? validate({required String label, required String? value}) {
    String? error;

    if (value?.trim().isNotEmpty == true) {
      for (var val in value!.trim().split(',').map((e) => e.trim())) {
        if (val.contains(' ')) {
          safePrint("Value $value , val $val");
          error = translate(
            FormValidationTranslations.form_validation_required,
            {
              'label': label,
            },
          );
        }
      }
    }

    return error;
  }
}
