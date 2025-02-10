import 'package:zachranobed/models/food_boxes_checkup.dart';

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

  /// The time (HH:mm) when pickup window starts.
  final String pickupTimeStart;

  /// The time (HH:mm) when pickup window ends.
  final String pickupTimeEnd;

  /// The food boxes checkup state of the donor.
  final FoodBoxesCheckup donorFoodBoxesCheckup;

  /// The food boxes checkup state of the recipient.
  final FoodBoxesCheckup recipientFoodBoxesCheckup;

  /// Creates a new [EntityPair] instance.
  EntityPair({
    required this.donorId,
    required this.donorEstablishmentName,
    required this.recipientId,
    required this.recipientEstablishmentName,
    required this.carrierId,
    required this.pickupTimeStart,
    required this.pickupTimeEnd,
    required this.donorFoodBoxesCheckup,
    required this.recipientFoodBoxesCheckup,
  });
}
