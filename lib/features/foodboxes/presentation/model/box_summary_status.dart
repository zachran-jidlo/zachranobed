import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/models/food_boxes_checkup.dart';
import 'package:zachranobed/models/user_data.dart';

/// A sealed class representing the status of the food box checkup.
///
/// This class is used to determine and represent different statuses that a food box checkup can have:
/// - `AllGood`: Checkup completed successfully and the status flag whether the checkup is verified or not.
/// - `Mismatch`: A mismatch was detected during the checkup.
/// - `CheckNeeded`: The checkup is needed and the user should perform further actions.
/// - `CheckInProgress`: The checkup is currently in progress.
/// - `Delayed`: The checkup has been delayed.
sealed class BoxSummaryStatus {
  /// Gets the status of the food box checkup for a given [user].
  static BoxSummaryStatus getStatus(UserData user) {
    final checkup = user.getFoodBoxesCheckup();
    final now = DateTime.now();

    BoxSummaryStatus status;
    switch (checkup.status) {
      case FoodBoxesCheckupStatus.ok:
        if (checkup.checkAt.isAfter(now)) {
          final verifiedUntil = checkup.verifiedAt?.add(const Duration(days: Constants.foodBoxesVerifiedThreshold));
          final isVerified = verifiedUntil?.isAfter(now) ?? false;
          status = AllGood(isVerified: isVerified);
        } else {
          final delayedUntil = checkup.checkAt.add(const Duration(days: Constants.foodBoxesCheckupMaxDelay));
          final isDelayAvailable = delayedUntil.isAfter(now);
          status = CheckNeeded(isDelayAvailable: isDelayAvailable);
        }

      case FoodBoxesCheckupStatus.delayed:
        final delayedUntil = checkup.checkAt.add(const Duration(days: Constants.foodBoxesCheckupMaxDelay));
        if (delayedUntil.isAfter(now)) {
          status = Delayed(duration: now.difference(checkup.checkAt));
        } else {
          status = CheckNeeded(isDelayAvailable: false);
        }

      case FoodBoxesCheckupStatus.mismatch:
        status = Mismatch();
    }

    return status;
  }
}

/// Represents the "All Good" status of a food box checkup.
class AllGood extends BoxSummaryStatus {
  /// Whether the food box checkup is verified (by admin or user).
  final bool isVerified;

  /// Creates an [AllGood] status.
  AllGood({required this.isVerified});
}

/// Represents the "Mismatch" status of a food box checkup.
class Mismatch extends BoxSummaryStatus {}

/// Represents the "Check Needed" status of a food box checkup.
class CheckNeeded extends BoxSummaryStatus {
  /// Whether the checkup delay is still available.
  final bool isDelayAvailable;

  /// Creates a [CheckNeeded] status.
  CheckNeeded({required this.isDelayAvailable});
}

/// Represents the "Check In Progress" status of a food box checkup.
class CheckInProgress extends BoxSummaryStatus {}

/// Represents the "Delayed" status of a food box checkup.
class Delayed extends BoxSummaryStatus {
  /// The duration of the delay.
  final Duration duration;

  /// Creates a [Delayed] status.
  Delayed({required this.duration});
}
