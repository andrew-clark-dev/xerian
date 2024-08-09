import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

/// Global configuration for the app, uses dorenv, env and shared preferences to
/// define app behavior

class AppConfig {
  static final skipLoad = dotenv.get('SKIP_LOAD', fallback: 'false') == 'true';

  static final String numberPattern = dotenv.get('NUMBER_PATTERN', fallback: "00000000");

  static final resetData = dotenv.get('RESET_DATA', fallback: 'false') == 'true';

  static final NumberFormat formatter = NumberFormat(numberPattern);

  static String format(num v) => formatter.format(v);

  static num toNum(String v) => formatter.parse(v);
}
