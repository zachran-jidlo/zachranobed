import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/models/user_data.dart';

import 'entity_pair.dart';

class Canteen extends UserData {
  Canteen({
    required super.entityId,
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    required super.lastAcceptedAppTermsVersion,
    required super.activePair,
    required super.hasMultiplePairs,
  });

  /// Checks if the current time is within the pickup range for a [Canteen].
  ///
  /// It splits the pickup times into parts, creates [DateTime] objects for them,
  /// and checks if the current time is within this range.
  ///
  /// Returns `true` if the current time is within the pickup range, `false` otherwise.
  bool isCurrentTimeWithinPickupRange() {
    DateTime now = DateTime.now();
    DateTime timeWithin =
        DateTimeUtils.getDateTimeOfCurrentDelivery(pickUpWithin);
    return now.isBefore(timeWithin);
  }

  String get pickUpFrom => activePair.pickupTimeStart;

  String get pickUpWithin => activePair.pickupTimeEnd;

  @override
  UserData copyWith({required EntityPair activePair}) {
    return Canteen(
      entityId: entityId,
      email: email,
      establishmentName: establishmentName,
      establishmentId: establishmentId,
      organization: organization,
      lastAcceptedAppTermsVersion: lastAcceptedAppTermsVersion,
      hasMultiplePairs: hasMultiplePairs,
      activePair: activePair,
    );
  }
}
