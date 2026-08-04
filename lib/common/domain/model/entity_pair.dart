import 'package:zachranobed/common/domain/model/food_boxes_checkup.dart';
import 'package:zachranobed/common/domain/model/local_time.dart';

/// Represents an entity pair between donor and recipient (canteen and charity).
class EntityPair {
  /// The entity ID of the donor entity.
  final String donorId;

  /// The name of the donor establishment.
  final String donorEstablishmentName;

  /// The entity ID of the recipient entity.
  final String recipientId;

  /// The name of the recipient establishment.
  final String recipientEstablishmentName;

  /// The carrier ID used for delivery.
  final String carrierId;

  /// The carrier ID used when the recipient returns boxes to the donor.
  final String boxReturnCarrierId;

  /// The time when pickup window starts.
  final LocalTime pickupTimeStart;

  /// The time when pickup window ends.
  final LocalTime pickupTimeEnd;

  /// The time when delivery window starts.
  final LocalTime deliveryTimeStart;

  /// The time when delivery window ends.
  final LocalTime deliveryTimeEnd;

  /// Whether pair uses returnable food boxes.
  final bool usesReturnableFoodBoxes;

  /// The food boxes checkup state of the donor.
  final FoodBoxesCheckup donorFoodBoxesCheckup;

  /// The food boxes checkup state of the recipient.
  final FoodBoxesCheckup recipientFoodBoxesCheckup;

  /// Whether the donor can record donations straight into history for this
  /// pair, bypassing the delivery process.
  final bool donorManualDonationEnabled;

  /// Whether the recipient can record donations straight into history for this
  /// pair, bypassing the delivery process.
  final bool recipientManualDonationEnabled;

  /// Whether the pickup confirmation feature is enabled for this pair.
  final bool pickupConfirmationEnabled;

  /// The confirmation time.
  final Duration confirmationTime;

  /// Creates a new [EntityPair] instance.
  EntityPair({
    required this.donorId,
    required this.donorEstablishmentName,
    required this.recipientId,
    required this.recipientEstablishmentName,
    required this.carrierId,
    required this.boxReturnCarrierId,
    required this.pickupTimeStart,
    required this.pickupTimeEnd,
    required this.deliveryTimeStart,
    required this.deliveryTimeEnd,
    required this.usesReturnableFoodBoxes,
    required this.donorFoodBoxesCheckup,
    required this.recipientFoodBoxesCheckup,
    required this.donorManualDonationEnabled,
    required this.recipientManualDonationEnabled,
    required this.pickupConfirmationEnabled,
    required this.confirmationTime,
  });
}
