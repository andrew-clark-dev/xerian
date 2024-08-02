import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/pages/account_view.dart';
import 'package:encoreshop/services/model_extensions.dart';
import 'package:flutter/material.dart';

import '../models/Account.dart';
import '../services/api.dart';

import 'package:go_router/go_router.dart';

import 'page_list_view_state.dart';

const limit = 20;

class AccountListView extends StatefulWidget {
  const AccountListView({super.key});

  static String get path => Account.classType.listPath;

  @override
  // ignore: library_private_types_in_public_api,
  AccountListViewState createState() => AccountListViewState();
}

class AccountListViewState extends PageListViewState<AccountListView> {
  @override
  void initState() {
    api = Api(Account.classType);
    super.initState();
  }

  @override
  ListTile tile(Model model) {
    Account account = model as Account;
    return ListTile(
      title: Row(
        children: [
          cell(formatter.format(account.number)),
          cell(account.firstName),
          cell(account.lastName),
          cell(account.phoneNumber),
          cell(account.email),
          cell(account.balance.toStringAsFixed(2)),
        ],
      ),
      onTap: () => context.push(AccountView.path, extra: account),
    );
  }

  @override
  ListTile get titleTile {
    final titles = ['Number', 'First Name', 'Last Name', 'Phone Number', 'Email', 'Balance'];
    return ListTile(
      title: Row(children: titles.map((t) => cell(t)).toList()),
    );
  }

  @override
  ModelType<Model> get modelType => Account.classType;
}
