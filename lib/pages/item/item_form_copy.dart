import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xerian/models/Category.dart' as cat;
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/services/search_service.dart';

import '../routable.dart';

class ItemFormX extends StatefulWidget implements RoutableExtra {
  final Item? account;
  const ItemFormX({
    super.key,
    this.account,
  });

  @override
  String get path => '/itemadd';

  @override
  extra(Object extra) => ItemFormX(account: extra as Item);

  @override
  State<ItemFormX> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemFormX> {
  SearchService ss = SearchService();
  final _formKey = GlobalKey<FormBuilderState>();

  List<cat.Category> _categorys = <cat.Category>[];

  @override
  void initState() {
    super.initState();
    _refreshCategorys();
  }

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
                  FormBuilderDropdown(
                    name: 'Department',
                    items: _categorys
                        .where((c) => c.type == CategoryType.department)
                        .map((c) => DropdownMenuItem<cat.Category>(
                            value: c, child: Text(c.value)))
                        .toList(),
                  ),
                ]))));
  }

  Future<void> _refreshCategorys() async {
    try {
      final request = ModelQueries.list(cat.Category.classType);
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        final categorys = response.data?.items;
        _categorys = categorys!.whereType<cat.Category>().toList();
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }
}
