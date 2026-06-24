import 'package:intl/intl.dart';

final NumberFormat currencyFormatter = NumberFormat.currency(
  locale: 'pl_PL',
  symbol: 'zł',
  decimalDigits: 2,
);

String formatCurrency(double amount) {
  return currencyFormatter.format(amount);
}
