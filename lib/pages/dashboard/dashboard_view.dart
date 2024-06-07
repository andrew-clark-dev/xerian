import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xerian/services/counter_service.dart';
import 'package:xerian/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

import '../../services/search_service.dart';
import '../routable.dart';

/// Displaysthe application dashboard.
class DashboardView extends StatelessWidget implements Routable {
  DashboardView({super.key});

  @override
  String get path => '/dashboard';

  final SearchService ss = SearchService();

  @override
  Widget build(BuildContext context) {
    CounterService.initialize();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.settings),
          //     onPressed: () {
          //       // Navigate to the settings page. If the user leaves and returns
          //       // to the app after it has been killed while running in the
          //       // background, the navigation stack is restored.
          //       Navigator.restorablePushNamed(context, SettingsView.routeName);
          //     },
          //   ),
          // ],
        ),
        drawer: const AppDrawer(), // Add the drawer here

        body: Center(
          child: Column(children: [
            ElevatedButton(
              onPressed: () {
                ss.accountSearch('Carissa');
              },
              child: const Text('Enabled'),
            ),
            TypeAheadField<SimpleSearchReponse>(
              suggestionsCallback: (search) => ss.accountSearch(search),
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
            )
          ]),
        ));
  }
}
