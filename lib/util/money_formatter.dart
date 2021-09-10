import 'package:intl/intl.dart';

class MoneyFormatter{
  static String format(double? price) {
    if (price != null) {
      final currencyFormatter = NumberFormat('#,##0', 'ID');
      return currencyFormatter.format(price);
    } else {
      return '0';
    }
  }
}