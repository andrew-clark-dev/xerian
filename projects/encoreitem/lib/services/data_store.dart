import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Account.dart';
import '../models/Category.dart' as c;
import '../models/Brand.dart';
import '../models/Color.dart';
import '../models/Size.dart';

class DataStore extends ChangeNotifier {
  static final DataStore _instance = DataStore._internal();

  factory DataStore() {
    return _instance;
  }

  final skipLoad = dotenv.get('SKIP_LOAD', fallback: 'false') == 'true';

  DataStore._internal();

  late final Database database;

  bool _ready = false;

  bool get ready => _ready;

  List<Account> accounts = [];

  List<Account> accountsByNumber(String matchString) {
    // var value = int.tryParse(matchString)?.toString() ?? "";
    return accounts.where((account) => account.number.startsWith(matchString)).take(10).toList();
  }

  List<c.Category> categories = [];

  List<c.Category> categoriesByName(String matchString) {
    return categories.where((item) => item.name.toLowerCase().startsWith(matchString.toLowerCase())).take(10).toList();
  }

  List<Brand> brands = [];

  List<Brand> brandsByName(String matchString) {
    return brands.where((item) => item.name.toLowerCase().startsWith(matchString.toLowerCase())).take(10).toList();
  }

  List<Color> colors = [];

  List<Color> colorsByName(String matchString) {
    return colors.where((item) => item.name.toLowerCase().startsWith(matchString.toLowerCase())).take(10).toList();
  }

  List<Size> sizes = [];

  List<Size> sizesByName(String matchString) {
    return sizes.where((item) => item.name.toLowerCase().startsWith(matchString.toLowerCase())).take(10).toList();
  }

  init() async {
    if (_ready) return;
    // await deleteDatabase(join(await getDatabasesPath(), 'model_database.db'));
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'model_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute('CREATE TABLE ${Account.classType.modelName()}(id TEXT PRIMARY KEY, json TEXT)');
        db.execute('CREATE TABLE ${c.Category.classType.modelName()}(id TEXT PRIMARY KEY, json TEXT)');
        db.execute('CREATE TABLE ${Brand.classType.modelName()}(id TEXT PRIMARY KEY, json TEXT)');
        db.execute('CREATE TABLE ${Color.classType.modelName()}(id TEXT PRIMARY KEY, json TEXT)');
        db.execute('CREATE TABLE ${Size.classType.modelName()}(id TEXT PRIMARY KEY, json TEXT)');
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );
    await _updateAll();
    _ready = true;
    notifyListeners();
  }

  Future<void> _updateAll() async {
    // Load and obtain the shared preferences for this app.
    final prefs = await SharedPreferences.getInstance();
    final thisUpdate = DateTime.now().toUtc().toIso8601String();
    final lastUpdate = prefs.getString('lastUpdate') ?? DateTime.utc(1900, 1, 1).toIso8601String();
    // final lastUpdate = DateTime.utc(1900, 1, 1).toIso8601String();

    safePrint("Update data from $lastUpdate to $thisUpdate");

    accounts = (await _load(Account.classType, lastUpdate)).map((account) => account as Account).toList();
    categories = (await _load(c.Category.classType, lastUpdate)).map((m) => m as c.Category).toList();
    brands = (await _load(Brand.classType, lastUpdate)).map((m) => m as Brand).toList();
    colors = (await _load(Color.classType, lastUpdate)).map((m) => m as Color).toList();
    sizes = (await _load(Size.classType, lastUpdate)).map((m) => m as Size).toList();

    prefs.setString('lastUpdate', thisUpdate);
    safePrint("Updated data  $thisUpdate");
  }

  Future<List<Model>> _load(ModelType modelType, String lastUpdate) async {
    if (!skipLoad) {
      safePrint("Loading $modelType");
      final queryPredicate = Account.UPDATEDAT.gt(lastUpdate);

      final request = ModelQueries.list(modelType, where: queryPredicate);
      final response = await Amplify.API.query(request: request).response;

      var data = response.data;

      List<Model> models = data?.items.nonNulls.toList() ?? <Model>[];

      while (data?.hasNextResult ?? false) {
        final nextResponse = await Amplify.API.query(request: data!.requestForNextResult!).response;
        data = nextResponse.data;
        var nextModels = data?.items.nonNulls.toList() ?? <Model>[];
        models.addAll(nextModels);
      }

      safePrint("${models.length} ${modelType.modelName()} updates found");

      safePrint("Updating application data");
      // Add the updates
      for (Model model in models) {
        final json = model.toJson();
        await database.insert(
          modelType.modelName(),
          {'id': json['id'], 'json': jsonEncode(json)},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      safePrint("${models.length} ${modelType.modelName()} added to db");
    }

    final List<Map<String, Object?>> modelMaps = await database.query(modelType.modelName());

    safePrint("${modelMaps.length} ${modelType.modelName()} in db");

    return modelMaps.map((modelMap) => modelType.fromJson(jsonDecode(modelMap['json'] as String))).toList();
  }
}
