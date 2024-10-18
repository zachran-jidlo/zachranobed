import 'package:flutter/material.dart';

/// A utility class for picking date and time using native dialogs.
class DateTimePicker {
  /// Private constructor to prevent instantiation.
  DateTimePicker._();

  /// Shows a date and time picker dialog and returns the selected [DateTime],
  /// or null if the user cancels the dialog. When the date picker is first
  /// displayed it will show the month of [initial], with [initial] selected.
  /// The [minimum] is the earliest allowable date.
  static Future<DateTime?> pickDateTime({
    required BuildContext context,
    required DateTime initial,
    DateTime? minimum,
  }) async {
    final date = await pickDate(
      context: context,
      initial: initial,
      minimum: minimum,
    );
    if (date == null || !context.mounted) return null;

    final time = await pickTime(
      context: context,
      initial: TimeOfDay(hour: initial.hour, minute: initial.minute),
    );
    if (time == null || !context.mounted) return null;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return dateTime;
  }

  /// Shows a date picker dialog and returns the selected [DateTime], or null
  /// if the user cancels the dialog. When the date picker is first displayed,
  /// it will show the month of [initial], with [initial] selected. The
  /// [minimum] is the earliest allowable date.
  static Future<DateTime?> pickDate({
    required BuildContext context,
    required DateTime initial,
    DateTime? minimum,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: minimum ?? DateTime(DateTime.now().year),
      lastDate: DateTime(2100),
    );
  }

  /// Shows a time picker dialog with [initial] equal to the current time.
  /// Returns the selected [TimeOfDay], or null if the user cancels the dialog.
  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
    required TimeOfDay initial,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initial,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
  }
}
