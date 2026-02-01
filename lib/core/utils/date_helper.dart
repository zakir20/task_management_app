import 'package:intl/intl.dart';

class DateHelper {
  // Returns 'Jan', 'Feb', etc.
  static String formatMonth(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  // Returns '01', '31', etc.
  static String formatDay(DateTime date) {
    return date.day.toString();
  }

  // Returns 'Mon', 'Tue', etc.
  static String formatWeekday(DateTime date) {
    return DateFormat('E').format(date);
  }
}