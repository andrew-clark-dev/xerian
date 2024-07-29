import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/pages/account_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Account.dart';
import '../services/api.dart';

import 'package:go_router/go_router.dart';

import 'pages.dart';

const limit = 20;

class AccountListView extends StatefulWidget {
  const AccountListView({super.key});

  static String get path => "/${Account.schema.pluralName!.toLowerCase()}";

  @override
  // ignore: library_private_types_in_public_api,
  AccountListViewState createState() => AccountListViewState();
}

class AccountListViewState extends State<AccountListView> {
  final NumberFormat formatter = NumberFormat("00000000");

  late final Api<Account> _api;

  @override
  void initState() {
    super.initState();
    _api = Api(Account.classType);
    fetchMore();
  }

  List<Account?> accounts = [];
  PaginatedResult<Account>? page;
  bool loading = true;

  final ScrollController controller = ScrollController();

  Future<void> fetchMore() async {
    loading = true;
    try {
      page = (await _api.fetch(page))!;
      setState(() {
        accounts += page!.items;
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    } finally {
      loading = false;
    }
  }

  Expanded cell(dynamic value) => Expanded(child: Text(value ?? "", textAlign: TextAlign.left));

  ListTile _tile(Account account) {
    return ListTile(
      title: Row(
        children: [
          cell(formatter.format(account.number)),
          cell(account.firstName),
          cell(account.lastName),
          cell(account.phoneNumber),
          cell(account.email),
          cell(account.balance!.toStringAsFixed(2)),
        ],
      ),
      onTap: () => context.push(AccountView.path, extra: account),
    );
  }

  ListTile _titleTile(List<String> titles) {
    return ListTile(
      title: Row(children: titles.map((t) => cell(t)).toList()),
    );
  }

  NotificationListener listener() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            controller.position.pixels >= controller.position.maxScrollExtent - 200 &&
            !loading) {
          // we need to call fetchmore logic here
          if (page!.hasNextResult && !loading) {
            // call here fetchMore
            fetchMore();
          }
        }
        return true;
      },
      child: ListView.builder(
          // attach the scroll controller to this List
          controller: controller,
          // we can pragmatically increase posts length by 1 to show a spinner for loading more
          itemCount: accounts.length + ((page?.hasNextResult ?? false) ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < accounts.length) {
              // you can have here your custom widgets for displaying posts or what
              return _tile(accounts[index]!);
            } else {
              return loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink();
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          // Navigate to the page to create new accounts
          onPressed: () => context.push(AccountView.path),
          child: const Icon(Icons.add),
        ),
        appBar: PageBar(Account.schema.pluralName!),
        drawer: const PageDrawer(), // Add the drawer here
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(children: [
              _titleTile(['Number', 'First Name', 'Last Name', 'Phone Number', 'Email', 'Balance']),
              const Divider(),
              Expanded(child: listener())
            ])));
  }
}

class AccountListTile extends ListTile {
  final Model model;
  final Row row;
  final String path;

  const AccountListTile(this.model, this.row, this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: row,
      onTap: () => context.push(path, extra: model),
    );
  }
}
