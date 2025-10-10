/// A sealed class representing the state of the food box checkup.
///
/// This class is used to determine and represent different states that a food box checkup can have:
/// - `AllGood`: Checkup completed successfully and the status flag whether the checkup is verified or not.
/// - `Mismatch`: A mismatch was detected during the checkup.
/// - `CheckNeeded`: The checkup is needed and the user should perform further actions.
/// - `CheckInProgress`: The checkup is currently in progress.
/// - `Delayed`: The checkup has been delayed.
sealed class FoodBoxesCheckupState {}

/// Represents the "All Good" state of a food box checkup.
class FoodBoxesCheckupAllGood extends FoodBoxesCheckupState {
  /// Whether the food box checkup is verified (by admin or user).
  final bool isVerified;

  /// Creates an [FoodBoxesCheckupAllGood] state.
  FoodBoxesCheckupAllGood({required this.isVerified});
}

/// Represents the "Mismatch" state of a food box checkup.
class FoodBoxesCheckupMismatch extends FoodBoxesCheckupState {}

/// Represents the "Check Needed" state of a food box checkup.
class FoodBoxesCheckupCheckNeeded extends FoodBoxesCheckupState {
  /// Whether the checkup delay is still available.
  final bool isDelayAvailable;

  /// Creates a [FoodBoxesCheckupCheckNeeded] state.
  FoodBoxesCheckupCheckNeeded({required this.isDelayAvailable});
}

/// Represents the "Check In Progress" state of a food box checkup.
class FoodBoxesCheckupCheckInProgress extends FoodBoxesCheckupState {}

/// Represents the "Delayed" state of a food box checkup.
class FoodBoxesCheckupDelayed extends FoodBoxesCheckupState {
  /// The duration of the delay.
  final Duration duration;

  /// Creates a [FoodBoxesCheckupDelayed] state.
  FoodBoxesCheckupDelayed({required this.duration});
}
