import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:xerian/models/Group.dart';
import 'package:xerian/pages/routable.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';

import '../../models/GroupType.dart';

class GroupView extends StatefulWidget implements RoutableExtra {
  final Group? group;
  const GroupView({
    super.key,
    this.group,
  });

  @override
  String get path => '/category';

  @override
  extra(Object extra) => GroupView(group: extra as Group);

  @override
  State<GroupView> createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupView> {
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

    var group = widget.group;

    if (group != null) {
      _typeController.text = group.type!.name;
      _valueController.text = group.value;
      _alternativesController.text = group.alternatives?.join(' ') ?? '';

      _titleText = 'Update Group';
    } else {
      _titleText = 'Create Group';
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    // If the form is valid, submit the data
    final type = GroupType.values.byName(_typeController.text);

    final value = _valueController.text;
    // Compress all white space just incase the user put in a few extra spaces
    final alternatives = _alternativesController.text.split(RegExp(' +'));

    // if (_isCreate) {
    // Create a new Group entry
    final newGroup =
        Group(type: type, value: value, alternatives: alternatives);

    final request = ModelMutations.create(newGroup);

    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Group details store failed'),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Group ${newGroup.value} details stored successfully'),
        ),
      );
    }

    // } else {
    //   // Update Group instead
    //   final updateGroup = _Group!.copyWith(
    //     firstName: firstName,
    //     lastName: lastName.isNotEmpty ? lastName : null,
    //   );
    //   await repo.put(updateGroup);
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
                        dropdownMenuEntries: GroupType.values
                            .map((e) => DropdownMenuEntry<GroupType>(
                                value: e, label: e.name))
                            .toList(),
                        initialSelection: GroupType.category),
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
