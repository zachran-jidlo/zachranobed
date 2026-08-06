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
  Stream<List<Delivery>> observeCurrentBoxDeliveries({
    required UserData user,
  }) {
    return _deliveryService
        .observeBoxDeliveries(
          donorId: user.activePair.donorId,
          recipientId: user.activePair.recipientId,
        )
        .map((event) => event.map((delivery) => delivery.toDomain()).nonNulls.toList());
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
  Future<bool> confirmPickup({
    required Delivery delivery,
  }) {
    return _deliveryService.confirmPickup(delivery.id);
  }

  @override
  Stream<bool> observeFoodBoxesTransferred({
    required String deliveryId,
  }) {
    return _deliveryService.observeDeliveryById(deliveryId).map((delivery) {
      if (delivery == null) {
        return false;
      }
      // Absent means an older app version moved the counts itself.
      return delivery.foodBoxesTransferred ?? true;
    });
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
      confirmationTime: user.activePair.confirmationTime.inMinutes,
      foodBoxesTransferred: null,
    );

    return _deliveryService.createDelivery(newDelivery);
  }
}
