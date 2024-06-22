import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:settings_ui/settings_ui.dart';

import '../routable.dart';

final Logger log = Logger("AdminSettings");

class AdminSettings extends StatelessWidget implements Routable {
  @override
  String get path => '/admin';

  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administration')),
      body: SettingsList(
        platform: DevicePlatform.web,
        sections: [
          SettingsSection(
            title: const Text('Auto-fill'),
            tiles: [
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.vpn_key),
                title: const Text('Passwords'),
              ),
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.credit_card_outlined),
                title: const Text('Payment methods'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Custom actions'),
            tiles: [
              SettingsTile(
                  title: const Text('Import accounts'),
                  leading: const Icon(Icons.warning_amber),
                  description: const Text('Import accounts from excel sheet.'),
                  onPressed: (_) {}),
              SettingsTile.navigation(
                onPressed: (_) async => null,
                leading: const Icon(Icons.warning_amber),
                title: const Text('Set ad preferences'),
                description: const Text(
                    'Set the account ad preferences based on a list of account numbers'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Future<void> processFile() async {
  //   NumberFormat formatter = NumberFormat("000000");

  //   var i = 0;

  //   var result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     var content = result.files.single.bytes!;
  //     var lines = LineSplitter.split(const Utf8Decoder().convert(content));
  //     for (var line in lines) {
  //       var key = line.split(',')[0].trim();
  //       if (key.isNotEmpty) {
  //         var number = formatter.format(int.parse(key));
  //         i += 1;

  //         final request = ExtendedModelQueries.listBy<Account>(
  //             Account.classType, Account.schema.indexes!.first, number);

  //         final incresponse =
  //             await Amplify.API.query(request: request).response;

  //         var items = incresponse.data!.items;

  //         if (items.isEmpty) {
  //           log.warning('$i - Number - $number not found');
  //         } else {
  //           Account account = items.first!;
  //           if (account.phoneNumber != null &&
  //               account.isMobile == true &&
  //               account.adprefs != AccountAdprefs.promoSms) {
  //             final update = account.copyWith(adprefs: AccountAdprefs.promoSms);
  //             final request = ModelMutations.update(update);
  //             await Amplify.API.mutate(request: request).response;
  //             safePrint('$i - Number - $number updated');
  //           } else {
  //             safePrint('$i - Number - $number NOT updated');
  //           }
  //         }
  //       }
  //     }
  //   }
  // }
}
