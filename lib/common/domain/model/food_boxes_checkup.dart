import 'package:zachranobed/common/domain/model/food_boxes_checkup_reported_count.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup_state.dart';
import 'package:zachranobed/common/domain/utils/constants.dart';

/// Represents the checkup state of food boxes.
class FoodBoxesCheckup {
  /// The current status of the food boxes checkup.
  final FoodBoxesCheckupStatus status;

  /// The date and time when the next checkup should be performed.
  final DateTime checkAt;

  /// The optional date and time when the checkup was verified.
  final DateTime? verifiedAt;

  /// Who performed the most recent change to the checkup state.
  final FoodBoxesCheckupLastChange lastChange;

  /// The per-box-type counts submitted by the user when the most recent
  /// mismatch was reported.
  final List<FoodBoxesCheckupReportedCount>? reportedCounts;

  /// Creates a new [FoodBoxesCheckup] instance.
  FoodBoxesCheckup({
    required this.status,
    required this.checkAt,
    required this.verifiedAt,
    required this.lastChange,
    this.reportedCounts,
  });

  /// Determines whether a checkup is currently needed.
  bool isCheckupNeeded() {
    final state = getState();
    return state is FoodBoxesCheckupCheckNeeded || state is FoodBoxesCheckupDelayed;
  }

  /// Gets the status of the food box checkup for a given [user].
  FoodBoxesCheckupState getState() {
    final now = DateTime.now();

    FoodBoxesCheckupState state;
    switch (status) {
      case FoodBoxesCheckupStatus.ok:
        if (checkAt.isAfter(now)) {
          final verifiedUntil = verifiedAt?.add(const Duration(days: Constants.foodBoxesVerifiedThreshold));
          final isVerified = verifiedUntil?.isAfter(now) ?? false;
          state = FoodBoxesCheckupAllGood(
            isVerified: isVerified,
            isVerifiedByUser: isVerified && lastChange == FoodBoxesCheckupLastChange.user,
          );
        } else {
          final delayedUntil = checkAt.add(const Duration(days: Constants.foodBoxesCheckupMaxDelay));
          final isDelayAvailable = delayedUntil.isAfter(now);
          state = FoodBoxesCheckupCheckNeeded(isDelayAvailable: isDelayAvailable);
        }
        break;

      case FoodBoxesCheckupStatus.delayed:
        final delayedUntil = checkAt.add(const Duration(days: Constants.foodBoxesCheckupMaxDelay));
        if (delayedUntil.isAfter(now)) {
          state = FoodBoxesCheckupDelayed(duration: delayedUntil.difference(now));
        } else {
          state = FoodBoxesCheckupCheckNeeded(isDelayAvailable: false);
        }
        break;

      case FoodBoxesCheckupStatus.mismatch:
        state = FoodBoxesCheckupMismatch();
        break;

      case FoodBoxesCheckupStatus.notNeeded:
        state = FoodBoxesCheckupAllGood(isVerified: false, isVerifiedByUser: false);
        break;
    }

    return state;
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

  /// The checkup is not needed.
  notNeeded,
}

/// Identifies who performed the most recent change to a food boxes checkup.
enum FoodBoxesCheckupLastChange {
  /// The user performed the most recent change.
  user,

  /// An admin performed the most recent change.
  admin,
}
