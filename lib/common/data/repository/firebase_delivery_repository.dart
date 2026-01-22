import 'package:zachranobed/common/data/dto/delivery_dto.dart';
import 'package:zachranobed/common/data/mapper/delivery_mapper.dart';
import 'package:zachranobed/common/data/service/delivery_service.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';

/// Implementation of the [DeliveryRepository] via Firebase services.
class FirebaseDeliveryRepository implements DeliveryRepository {
  final DeliveryService _deliveryService;

  final List<DeliveryState> closedStates = [
    DeliveryState.inDelivery,
    DeliveryState.delivered,
    DeliveryState.notUsed,
  ];

  FirebaseDeliveryRepository(this._deliveryService);

  @override
  Stream<Delivery?> observeCurrentDelivery({
    required UserData user,
  }) {
    return _deliveryService
        .observeDelivery(
          donorId: user.activePair.donorId,
          recipientId: user.activePair.recipientId,
        )
        .map((event) => event?.toDomain());
  }

  @override
  Future<bool> updateDeliveryState({
    required Delivery delivery,
    required DeliveryState state,
  }) {
    return _deliveryService.updateDeliveryState(
      delivery.id,
      state.toDto(),
    );
  }

  @override
  bool canDonateFood({required Delivery delivery, required DateTime time}) {
    if (closedStates.contains(delivery.state)) {
      return false;
    }

    final pickupDuration = Duration(minutes: delivery.confirmationTime);
    final canDonateUntil = time.subtract(pickupDuration);
    if (delivery.state == DeliveryState.prepared && DateTime.now().isAfter(canDonateUntil)) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> createFoodDelivery({
    required UserData user,
  }) async {
    final donorId = user.activePair.donorId;
    final recipientId = user.activePair.recipientId;

    // Prepare delivery ID and check if any exists in Firebase
    final id = '$donorId-$recipientId-${DateTimeUtils.getCurrentDayMark()}';
    final existingDelivery = await _deliveryService.getDeliveryById(id);

    // If delivery already exists, return success without creating a new one
    if (existingDelivery != null) {
      return true;
    }

    // Create a new empty delivery in prepared state
    final newDelivery = DeliveryDto(
      id: id,
      donorId: donorId,
      recipientId: recipientId,
      deliveryDate: DateTimeUtils.lastMidnight(),
      foodBoxes: [],
      meals: [],
      state: DeliveryStateDto.prepared,
      type: DeliveryTypeDto.foodDelivery,
      confirmationTime: user.activePair.confirmationTime,
    );

    return _deliveryService.createDelivery(newDelivery);
  }
}
