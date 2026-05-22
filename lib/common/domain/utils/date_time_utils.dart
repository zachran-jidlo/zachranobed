import 'package:intl/intl.dart';

/// Date-time related utility functions.
class DateTimeUtils {
  /// Private constructor to prevent instantiation.
  DateTimeUtils._();

  /// Returns a [DateTime] object representing the start of the current day.
  static DateTime lastMidnight() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Returns a [String] with current day in 'yyyy-MM-dd' format.
  static String getCurrentDayMark() {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(DateTime.now());
  }

  /// Calculates the timestamp for the next food boxes check at 7:00 AM UTC.
  /// Checkups run twice a month, on the first and the third Friday.
  /// The optional [now] parameter is intended for tests, production code should
  /// rely on the default value.
  static DateTime getNextFoodBoxesCheckDateTime({DateTime? now}) {
    final reference = now ?? DateTime.now();

    final candidates = [
      _nthFridayOfMonth(reference.year, reference.month, 1),
      _nthFridayOfMonth(reference.year, reference.month, 3),
      _nthFridayOfMonth(reference.year, reference.month + 1, 1),
    ];

    final next = candidates.firstWhere((date) => date.isAfter(reference));
    return DateTime.utc(next.year, next.month, next.day, 7, 0, 0);
  }

  /// Returns the [n]-th Friday of the given month.
  static DateTime _nthFridayOfMonth(int year, int month, int n) {
    final firstOfMonth = DateTime(year, month, 1);
    final offsetToFirstFriday = (5 - firstOfMonth.weekday + 7) % 7;
    return firstOfMonth.add(Duration(days: offsetToFirstFriday + (n - 1) * 7));
  }

  /// Returns a [String] with current time in 'HH:mm' format.
  static String formatDateTime(DateTime dateTime, String format) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  }

  /// Returns `true` if the given [date] is the same as today's date.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
