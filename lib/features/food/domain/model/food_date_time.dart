/// Represents the date and time information for food donation.
sealed class FoodDateTime {
  /// Returns the specified date and time, or null if date is specified on the
  /// packaging.
  DateTime? getDate();
}

/// Represents a food date and time that is explicitly specified.
class FoodDateTimeSpecified extends FoodDateTime {
  /// The specified date and time.
  final DateTime date;

  /// Creates a [FoodDateTimeSpecified] instance.
  FoodDateTimeSpecified({required this.date});

  @override
  DateTime? getDate() => date;
}

/// Represents a food date and time that is specified on the packaging itself.
class FoodDateTimeOnPackaging extends FoodDateTime {
  @override
  DateTime? getDate() => null;
}
