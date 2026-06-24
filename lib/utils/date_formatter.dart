import 'package:intl/intl.dart';

final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');

String formatDate(DateTime date) {
  return dateFormatter.format(date);
}
