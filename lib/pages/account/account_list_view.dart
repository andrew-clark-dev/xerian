import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:xerian/models/Account.dart';
import 'package:xerian/services/counter_service.dart';
import 'package:xerian/services/row_service.dart';
import 'package:xerian/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AccountListView extends StatefulWidget {
  static const path = '/accounts';
  const AccountListView({super.key});

  @override
  State<AccountListView> createState() => _AccountListViewState();
}

class _AccountListViewState extends State<AccountListView> {
  List<Account> _accounts = <Account>[];

  final NumberFormat formatter = NumberFormat("00000000");

  // Define variables for managing list data and scrolling
  final ScrollController _scrollController = ScrollController();
  // Method to add more data when scrolling reaches the end
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _refreshAccounts();
    }
  }

  @override
  void initState() {
    super.initState();
    CounterService.initialize();
    _refreshAccounts();
    // Attach listener to scroll controller
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _refreshAccounts() async {
    try {
      final request = ModelQueries.list(Account.classType);
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        final accounts = response.data?.items;
        _accounts = accounts!.whereType<Account>().toList();
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }

  Future<void> _deleteAccount(Account account) async {
    final request = ModelMutations.delete<Account>(account);
    final response = await Amplify.API.mutate(request: request).response;
    safePrint('Delete response: $response');
    await _refreshAccounts();
  }

  Future<void> _navigateToAccount({Account? account}) async {
    context.push('/account', extra: account);
    // Refresh the entries when returning from Account detail screen.
    await _refreshAccounts();
  }

  Widget _buildRow(Account account, {TextStyle? style}) {
    return RowService.buildRow([
      formatter.format(account.number),
      account.firstName,
      account.lastName,
      account.email,
      account.phoneNumber
    ], style);
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
      drawer: const AppDrawer(), // Add the drawer here

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: RefreshIndicator(
            onRefresh: _refreshAccounts,
            child: Column(
              children: [
                const SizedBox(height: 30),
                RowService.buildRow(
                  [
                    'Number',
                    'First Name',
                    'Last Name',
                    "E-Mail",
                    "Phone Number"
                  ],
                  Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
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
                              title: _buildRow(account)));
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
