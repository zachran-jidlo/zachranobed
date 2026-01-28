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

  /// Calculates the timestamp for the next food boxes check. This function determines the first Friday of the next
  /// month at 7:00 AM UTC.
  static DateTime getNextFoodBoxesCheckDateTime() {
    final now = DateTime.now();
    final firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

    // Adjust to the first Friday
    final dayOffset = (5 - firstDayOfNextMonth.weekday + 7) % 7;
    final nextMonthFriday = firstDayOfNextMonth.add(Duration(days: dayOffset));

    return DateTime.utc(nextMonthFriday.year, nextMonthFriday.month, nextMonthFriday.day, 7, 0, 0);
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
