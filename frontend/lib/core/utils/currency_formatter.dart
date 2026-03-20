import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _zar = NumberFormat.currency(
    locale: 'en_ZA',
    symbol: 'R ',
    decimalDigits: 2,
  );

  static final _zarCompact = NumberFormat.compactCurrency(
    locale: 'en_ZA',
    symbol: 'R',
    decimalDigits: 0,
  );

  /// Format as full ZAR: R 1 250.00
  static String format(double amount) => _zar.format(amount);

  /// Format compact: R1.2k
  static String compact(double amount) => _zarCompact.format(amount);

  /// Format without symbol: 1 250.00
  static String plain(double amount) =>
      NumberFormat('#,##0.00', 'en_ZA').format(amount);
}
