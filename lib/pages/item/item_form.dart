import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xerian/models/Account.dart';
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
  void extra(Object extra) => ItemForm(account: extra as Item);

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  SearchService ss = SearchService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Item"),
        ),
        body: Align(
            alignment: Alignment.topCenter,
            child: TypeAheadField<Account>(
              suggestionsCallback: (search) => ss.accountCallback(search),
              builder: (context, controller, focusNode) {
                return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City',
                    ));
              },
              itemBuilder: (context, city) {
                return ListTile(
                  title: Text(city.number),
                  subtitle: Text(city.firstName),
                );
              },
              onSelected: (city) {
                // Navigator.of(context).push<void>(
                //   MaterialPageRoute(
                //     builder: (context) => CityPage(city: city),
                //   ),
                // );
              },
            )));
  }
}
