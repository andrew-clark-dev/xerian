import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Utilities {
  static final String numberPattern = dotenv.get('NUMBER_PATTERN', fallback: "00000000");

  static final Utilities _instance = Utilities._internal();

  factory Utilities() {
    return _instance;
  }

  Utilities._internal();

  static final NumberFormat formatter = NumberFormat(numberPattern);
}
