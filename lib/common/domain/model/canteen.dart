import 'package:zachranobed/common/domain/model/entity_pair.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup.dart';
import 'package:zachranobed/common/domain/model/local_time.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';

class Canteen extends UserData {
  Canteen({
    required super.entityId,
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    required super.lastAcceptedAppTermsVersion,
    required super.activePair,
    required super.allPairs,
  });

  /// Checks if the current time is within the pickup range for a [Canteen].
  ///
  /// It splits the pickup times into parts, creates [DateTime] objects for them,
  /// and checks if the current time is within this range.
  ///
  /// Returns `true` if the current time is within the pickup range, `false` otherwise.
  bool isCurrentTimeWithinPickupRange() {
    return DateTime.now().isBefore(pickUpWithin.atToday());
  }

  LocalTime get pickUpFrom => activePair.pickupTimeStart;

  LocalTime get pickUpWithin => activePair.pickupTimeEnd;

  @override
  UserData copyWith({required EntityPair activePair}) {
    return Canteen(
      entityId: entityId,
      email: email,
      establishmentName: establishmentName,
      establishmentId: establishmentId,
      organization: organization,
      lastAcceptedAppTermsVersion: lastAcceptedAppTermsVersion,
      allPairs: allPairs,
      activePair: activePair,
    );
  }

  @override
  FoodBoxesCheckup getFoodBoxesCheckup(EntityPair pair) => pair.donorFoodBoxesCheckup;
}
