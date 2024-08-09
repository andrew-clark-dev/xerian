import 'package:encoreitem/form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/counter_service.dart';
import 'services/data_store.dart';
import 'splash.dart';

class ItemApp extends StatelessWidget {
  const ItemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item',
      home: Consumer<DataStore>(
        builder: (context, store, child) {
          if (store.ready) {
            return const ItemForm();
          } else {
            CounterService.initialize();
            DataStore().init();
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
