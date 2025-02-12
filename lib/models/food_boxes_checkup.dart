/// Represents the checkup state of food boxes.
class FoodBoxesCheckup {
  /// The current status of the food boxes checkup.
  final FoodBoxesCheckupStatus status;

  /// The date and time when the next checkup should be performed.
  final DateTime checkAt;

  /// The optional date and time when the checkup was verified.
  final DateTime? verifiedAt;

  /// Creates a new [FoodBoxesCheckup] instance.
  FoodBoxesCheckup({
    required this.status,
    required this.checkAt,
    required this.verifiedAt,
  });

  /// Creates a default [FoodBoxesCheckup] instance with an "ok" status for new users.
  FoodBoxesCheckup.createDefault()
      : status = FoodBoxesCheckupStatus.ok,
        checkAt = DateTime.now(),
        verifiedAt = null;

  /// Determines whether a checkup is currently needed.
  bool isCheckupNeeded() {
    final now = DateTime.now();
    return status == FoodBoxesCheckupStatus.ok && now.isAfter(checkAt) || status == FoodBoxesCheckupStatus.delayed;
  }
}

/// Represents the possible statuses of a food boxes checkup.
enum FoodBoxesCheckupStatus {
  /// The checkup was completed or has yet to be completed.
  ok,

  /// The checkup has been delayed.
  delayed,

  /// A mismatch was found during the checkup.
  mismatch,
}
