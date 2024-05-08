import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/repository.dart';
import 'account.dart';

const path = '/accounts';

class AccountsView extends StatefulWidget {
  const AccountsView({super.key});

  @override
  State<AccountsView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountsView> {
  List<Account> _accounts = <Account>[];
  Repository repo = Repository("xerian-account-entity-dev");

  @override
  void initState() {
    super.initState();
    _refreshAccounts();
  }

  Future<void> _refreshAccounts() async {
    final page = await repo.getNextPage();
    setState(() {
      _accounts = Account.fromJsonList(page);
    });
  }

  Future<void> _deleteAccount(Account account) async {
    // final request = ModelMutations.delete<Account>(account);
    // final response = await Amplify.API.mutate(request: request).response;
    // safePrint('Delete response: $response');
    // await _refreshAccounts();
  }

  Future<void> _navigateToAccount({Account? account}) async {
    context.push('/account');
    // Refresh the entries when returning from Account detail screen.
    await _refreshAccounts();
  }

  double _calculateTotalBudget(List<Account?> items) {
    // var totalAmount = 0.0;
    // for (final item in items) {
    //   totalAmount += item?.number ?? 0;
    // }
    // return totalAmount;
    return 0.0;
  }

  Widget _buildRow({
    required String firstName,
    required String lastName,
    required String number,
    TextStyle? style,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            firstName,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
        Expanded(
          child: Text(
            lastName,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
        Expanded(
          child: Text(
            number,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // Navigate to the page to create new budget entries
        onPressed: _navigateToAccount,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: RefreshIndicator(
            onRefresh: _refreshAccounts,
            child: Column(
              children: [
                if (_accounts.isEmpty)
                  const Text('Use the \u002b sign to add new budget entries')
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Show total budget from the list of all BudgetEntries
                      Text(
                        'Total Budget: \$ ${_calculateTotalBudget(_accounts).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24),
                      )
                    ],
                  ),
                const SizedBox(height: 30),
                _buildRow(
                  firstName: 'First Name',
                  lastName: 'Last Name',
                  number: 'Number',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _accounts.length,
                    itemBuilder: (context, index) {
                      final account = _accounts[index];
                      return Dismissible(
                        key: const ValueKey(Account),
                        background: const ColoredBox(
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ),
                        onDismissed: (_) => _deleteAccount(account),
                        child: ListTile(
                          onTap: () => _navigateToAccount(
                            account: account,
                          ),
                          title: _buildRow(
                            firstName: account.firstName,
                            lastName: account.lastName,
                            number: '\$ ${account.number.toStringAsFixed(2)}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
