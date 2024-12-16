import 'package:intl/intl.dart';

String formatCurrency(int value) {
  return NumberFormat.currency(
    locale: 'en_US',  // Locale for the desired formatting
    symbol: '\$',     // Currency symbol
    decimalDigits: 0, // No decimal places
  ).format(value);
}