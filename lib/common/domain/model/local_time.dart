/// A time of day without a date or timezone, in the ISO-8601 calendar system.
///
/// [LocalTime] is an immutable object representing a time, such as "10:15" or "17:30".
/// It is comprised of an [hour] (0-23) and a [minute] (0-59).
class LocalTime {
  /// The hour of the day, ranging from 0 to 23.
  final int hour;

  /// The minute of the hour, ranging from 0 to 59.
  final int minute;

  /// Creates a [LocalTime] instance.
  ///
  /// Requires [hour] to be between 0 and 23, and [minute] to be between 0 and 59.
  /// Throws an [AssertionError] in debug mode if values are out of range.
  const LocalTime({
    required this.hour,
    required this.minute,
  }) : assert(hour >= 0 && hour <= 23, 'Hour must be between 0 and 23'),
       assert(minute >= 0 && minute <= 59, 'Minute must be between 0 and 59');

  /// Returns a [DateTime] combining today's date with this time.
  ///
  /// This uses [DateTime.now()] to determine the current year, month, and day, and sets the second and
  /// millisecond to 0.
  DateTime atToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  /// Returns a string representation of this time in "HH:mm" format.
  ///
  /// Both [hour] and [minute] are zero-padded to two digits.
  @override
  String toString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Compares this [LocalTime] to [other] for equality.
  ///
  /// Returns `true` if both [hour] and [minute] are identical.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocalTime && other.hour == hour && other.minute == minute;
  }

  /// The hash code for this object.
  ///
  /// Computed using [Object.hash] on [hour] and [minute].
  @override
  int get hashCode => Object.hash(hour, minute);
}
