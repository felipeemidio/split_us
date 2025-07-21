import 'package:intl/intl.dart';

abstract class TextFormatter {
  const TextFormatter._();

  static const _noDigits = r"[^0-9]";

  static String onlyDigits(String text) {
    return text.replaceAll(RegExp(_noDigits), '');
  }

  static String currency(double value, String symbol) {
    var f = NumberFormat.currency(locale: 'pt_BR', symbol: symbol);
    return f.format(value);
  }

  static double currencyToValue(String? value) {
    if (value == null || value.isEmpty) {
      return 0.0;
    }

    final digits = onlyDigits(value);
    final numericValue = int.tryParse(digits) ?? 0;

    return numericValue / 100;
  }
}
