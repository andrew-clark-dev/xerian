import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:xerian/models/CategoryType.dart';

import '../models/Category.dart' as model;

abstract class DropDown<Model> extends StatefulWidget {
  const DropDown({super.key});
}

class DepartmentDropDown<Model> extends DropDown {
  const DepartmentDropDown({super.key});
  @override
  State<DropDown> createState() => _DepartmentState();
}

class BrandDropDown<Model> extends DropDown {
  const BrandDropDown({super.key});
  @override
  State<DropDown> createState() => _BrandState();
}

class ColourDropDown<Model> extends DropDown {
  const ColourDropDown({super.key});
  @override
  State<DropDown> createState() => _ColourState();
}

class SizeDropDown<Model> extends DropDown {
  const SizeDropDown({super.key});
  @override
  State<DropDown> createState() => _SizeState();
}

abstract class _DropDownState extends State<DropDown> {
  final TextEditingController _modelController = TextEditingController();

  Model? selectedModel;

  List<Model> _models = <Model>[];

  @override
  void initState() {
    super.initState();
    _refreshModels();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<Model>(
      controller: _modelController,
      enableFilter: true,
      requestFocusOnTap: true,
      leadingIcon: const Icon(Icons.search),
      label: Text(menuLabel()),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      ),
      onSelected: (Model? model) {
        setState(() {
          selectedModel = model;
        });
      },
      dropdownMenuEntries: _models.map<DropdownMenuEntry<Model>>(
        (Model model) {
          return DropdownMenuEntry<Model>(
            value: model,
            label: model.label,
            leadingIcon: model.icon,
          );
        },
      ).toList(),
      width: 400,
    );
  }

  Future<void> _refreshModels() async {
    try {
      var items = await getModels();
      setState(() {
        _models = items;
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }

  Future<List<Model>> getModels();

  String menuLabel();
}

abstract class _CategoryState extends _DropDownState {
  CategoryType categoryType();
  @override
  menuLabel() => categoryType().name;
  @override
  getModels() async {
    final request = ModelQueries.list(model.Category.classType);
    final response = await Amplify.API.query(request: request).response;
    if (response.hasErrors) {
      throw "Cannot read Department state, errors: ${response.errors}";
    }
    final items = response.data?.items;
    if (items == null) return [];
    return items
        .whereType<model.Category>()
        .where((m) => m.type == categoryType())
        .toList();
  }
}

class _DepartmentState extends _CategoryState {
  @override
  CategoryType categoryType() => CategoryType.department;
}

class _ColourState extends _CategoryState {
  @override
  CategoryType categoryType() => CategoryType.colour;
}

class _BrandState extends _CategoryState {
  @override
  CategoryType categoryType() => CategoryType.brand;
}

class _SizeState extends _CategoryState {
  @override
  CategoryType categoryType() => CategoryType.size;
}

extension CategoryMenuItems on Model {
  get label {
    switch (runtimeType) {
      case const (model.Category):
        return (this as model.Category).value;
    }
    return null;
  }

  get icon => const Icon(Icons.local_offer);
}
