import 'package:intl/intl.dart';

extension CurrencyExtension on num {
  brl({bool hideSymbol = false}) {
    var f = NumberFormat.currency(locale: 'pt_BR', symbol: hideSymbol ? '' : 'R\$ ');

    return f.format(this);
  }
}
