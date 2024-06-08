import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xerian/models/Item.dart';
import 'package:xerian/services/search_service.dart';

import '../routable.dart';

class ItemForm extends StatefulWidget implements RoutableExtra {
  final Item? account;
  const ItemForm({
    super.key,
    this.account,
  });

  @override
  String get path => '/itemadd';

  @override
  extra(Object extra) => ItemForm(account: extra as Item);

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  SearchService ss = SearchService();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Item"),
        ),
        body: SingleChildScrollView(
            child: FormBuilder(
                key: _formKey,
                child: Column(children: <Widget>[
                  FormBuilderField(
                    name: "account",
                    builder: (FormFieldState<dynamic> field) {
                      return TypeAheadField<SimpleSearchReponse>(
                        suggestionsCallback: (search) =>
                            ss.accountSearch(search),
                        builder: (context, controller, focusNode) {
                          return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              autofocus: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Account',
                              ));
                        },
                        itemBuilder: (context, simpleSearchResponse) {
                          return ListTile(
                            title: Text(simpleSearchResponse.title ?? ""),
                            subtitle: Text(simpleSearchResponse.subtitle ?? ""),
                          );
                        },
                        onSelected: (SimpleSearchReponse value) {},
                      );
                    },
                  ),
                ]))));
  }
}
