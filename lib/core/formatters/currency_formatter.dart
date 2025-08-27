import 'package:flutter/services.dart';
import 'package:splitus/core/formatters/text_formatter.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    final digits = TextFormatter.onlyDigits(newValue.text);
    final double value = double.parse(digits.isEmpty ? '0' : digits);
    final formattedValue = TextFormatter.currency(double.parse((value / 100).toStringAsFixed(2)), '');

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class IntegerInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    final digits = TextFormatter.onlyDigits(newValue.text);

    return newValue.copyWith(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}
