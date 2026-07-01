import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _format = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'ZWG ',
    decimalDigits: 0,
  );

  static String format(double amount) => _format.format(amount);
}
