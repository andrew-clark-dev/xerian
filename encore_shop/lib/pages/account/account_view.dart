import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encore_shop/models/Account.dart';
import 'package:encore_shop/services/counter_service.dart';
import 'package:encore_shop/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountView extends StatefulWidget {
  static const path = '/account';

  final Account? account;
  const AccountView({
    super.key,
    this.account,
  });

  @override
  State<AccountView> createState() => _AccountListViewState();
}

class _AccountListViewState extends State<AccountView> {
  final _formKey = GlobalKey<FormState>();

  final NumberFormat formatter = NumberFormat("00000000");
  final CounterService counter = CounterService(Account.classType);

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  late final String _titleText;

  @override
  void initState() {
    super.initState();

    var account = widget.account;

    if (account != null) {
      _firstNameController.text = account.firstName!;
      _lastNameController.text = account.lastName!;
      _numberController.text = formatter.format(account.number);
      _titleText = 'Update account';
    } else {
      _titleText = 'Create account';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(ScaffoldMessengerState scaffoldMessenger) async {
    // If the form is valid, submit the data
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;

    // if (_isCreate) {
    // Create a new account entry
    final newAccount = Account(
      number: await counter.next(),
      firstName: firstName,
      lastName: lastName,
    );

    final request = ModelMutations.create(newAccount);

    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Account details store failed'),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content:
              Text('Account ${newAccount.number} details stored successfully'),
        ),
      );
    }

    // } else {
    //   // Update account instead
    //   final updateAccount = _account!.copyWith(
    //     firstName: firstName,
    //     lastName: lastName.isNotEmpty ? lastName : null,
    //   );
    //   await repo.put(updateAccount);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText),
      ),
      drawer: const AppDrawer(), // Add the drawer here
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
                      controller: _numberController,
                      decoration: const InputDecoration(
                        labelText: 'Number',
                      ),
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a first name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
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
