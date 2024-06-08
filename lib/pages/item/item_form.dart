import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../services/search_service.dart';
import '../../widgets/dropdown.dart';
import '../routable.dart';

// Define a custom Form widget.
class ItemForm extends StatefulWidget implements Routable {
  const ItemForm({super.key});

  @override
  String get path => '/newitem';

  @override
  ItemFormState createState() {
    return ItemFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class ItemFormState extends State<ItemForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<ItemFormState>.
  final _formKey = GlobalKey<FormState>();

  final searchService = SearchService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Item"),
        ),
        body: Form(
          // Build a Form widget using the _formKey created above.
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TypeAheadField<SimpleSearchReponse>(
                suggestionsCallback: (search) =>
                    searchService.accountSearch(search),
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
              ),
              const SizedBox(width: 100),
              const DepartmentDropDown(),
              const ColourDropDown(),
              const BrandDropDown(),
              const SizeDropDown(),
            ],
          ),
        ));
  }
}
