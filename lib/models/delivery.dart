import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/common/constants.dart';

/*
 * Command to rebuild the delivery.g.dart file:
 * flutter pub run build_runner build --delete-conflicting-outputs
 */
part 'delivery.freezed.dart';

@Freezed()
class Delivery with _$Delivery {
  const Delivery._();
  const factory Delivery({
    required String id,
    required String donorId,
    required String recipientId,
    required DeliveryState state,
    required DeliveryType type,
    required int confirmationTime,
  }) = _Delivery;
}

enum DeliveryState {
  prepared,
  offered,
  accepted,
  inDelivery,
  delivered,
  notUsed,
}

enum DeliveryType {
  foodDelivery,
  boxDelivery,
}
