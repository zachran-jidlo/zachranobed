import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/common/domain/model/carrier_type.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';

/*
 * Command to rebuild the delivery.g.dart file:
 * flutter pub run build_runner build --delete-conflicting-outputs
 */
part 'delivery.freezed.dart';

@freezed
abstract class Delivery with _$Delivery {
  const Delivery._();
  const factory Delivery({
    required String id,
    required String donorId,
    required String recipientId,
    required DeliveryState state,
    required DeliveryType type,
    required Duration confirmationTime,
    required bool hasMeals,
    required bool isPickupConfirmed,
  }) = _Delivery;

  /// Whether the pickup confirmation flow applies right now for [user]'s active
  /// pair. Only self-pickup pairs with the feature enabled, in the accepted
  /// state, and before the canteen adds meals. Once meals are added,
  /// confirmation is no longer needed.
  bool isPickupConfirmationActive(UserData user) {
    final pair = user.activePair;
    return pair.carrierId == CarrierType.personal.id &&
        pair.pickupConfirmationEnabled &&
        state == DeliveryState.accepted &&
        !hasMeals;
  }
}

enum DeliveryState {
  prepared,
  accepted,
  onWayToPickUp,
  inDelivery,
  delivered,
  done,
  notUsed,
}

enum DeliveryType {
  foodDelivery,
  boxDelivery,
}
