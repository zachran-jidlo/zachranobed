import 'package:zachranobed/models/user_data.dart';

import '../common/utils/date_time_utils.dart';

class Canteen extends UserData {
  final String pickUpFrom;
  final String pickUpWithin;
  final String recipientId;

  Canteen({
    required super.entityId,
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    required super.lastAcceptedAppTermsVersion,
    required this.pickUpFrom,
    required this.pickUpWithin,
    required this.recipientId,
  });

  /// Checks if the current time is within the pickup range for a [Canteen].
  ///
  /// It splits the pickup times into parts, creates [DateTime] objects for them,
  /// and checks if the current time is within this range.
  ///
  /// Returns `true` if the current time is within the pickup range, `false` otherwise.
  bool isCurrentTimeWithinPickupRange() {
    DateTime now = DateTime.now();
    DateTime timeFrom = DateTimeUtils.getTime(pickUpFrom, now);
    DateTime timeWithin = DateTimeUtils.getTime(pickUpWithin, now);
    return now.isAfter(timeFrom) && now.isBefore(timeWithin);
  }
}
