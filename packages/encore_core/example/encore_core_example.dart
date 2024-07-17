import 'package:amplify_core/amplify_core.dart';
import 'package:encore_core/encore_core.dart';

Future<void> main() async {
  final loggedIn = await Amplify.Auth.isAuthorized;
  print('loggedIn: $loggedIn');
}
