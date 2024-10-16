import 'package:intl/intl.dart';

/// Date-time related utility functions.
class DateTimeUtils {
  /// Returns date of start of the week (monday) for the given [date].
  static DateTime getWeekStart(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1));

  /// Returns date of previous week for the given [date].
  static DateTime getPreviousWeek(DateTime date) =>
      DateTime(date.year, date.month, date.day - 7);

  /// Returns date of next week for the given [date].
  static DateTime getNextWeek(DateTime date) =>
      DateTime(date.year, date.month, date.day + 7);

  /// Returns a [String] representing the date range for a week specified by
  /// [week] formatted as:
  /// 'week start (d. MMMM) - week end (d. MMMM) year (yyyy)'.
  /// or when start and end have different years:
  /// 'week start (d. MMMM) year (yyyy) - week end (d. MMMM) year (yyyy)'.
  static String getTitleForWeek(DateTime week) {
    final weekEnd = week.add(const Duration(days: 6));
    final formatter = DateFormat('d. MMMM', 'cs');
    final String yearStart;
    final String yearEnd;
    if (week.year == weekEnd.year) {
      yearStart = '';
      yearEnd = ' ${weekEnd.year}';
    } else {
      yearStart = ' ${week.year}';
      yearEnd = ' ${weekEnd.year}';
    }

    return '${formatter.format(week)}$yearStart - ${formatter.format(weekEnd)}$yearEnd';
  }

  /// Returns a [DateTime] object representing the parsed date and [time] of
  /// delivery for today.
  static DateTime getDateTimeOfCurrentDelivery(String time) {
    final timePart = DateFormat('HH:mm').parse(time);
    final duration = Duration(hours: timePart.hour, minutes: timePart.minute);
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).add(duration);
  }

  /// Returns a [String] with current day in 'yyyy-MM-dd' format.
  static String getCurrentDayMark() {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(DateTime.now());
  }

  /// Returns a [String] with current time in 'HH:mm' format.
  String formatDateTime(DateTime dateTime, String format) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  }
}
