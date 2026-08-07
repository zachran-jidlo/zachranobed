import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';

/// Repository for managing deliveries.
abstract class DeliveryRepository {
  /// Observes the current delivery for a given [user].
  Stream<Delivery?> observeCurrentDelivery({
    required UserData user,
  });

  /// Observes today's box returns for a given [user]. Emits an empty list when
  /// there is none. More than one return can land on the same day.
  Stream<List<Delivery>> observeCurrentBoxDeliveries({
    required UserData user,
  });

  /// Updates the state of a [delivery] with the provided [state].
  Future<bool> updateDeliveryState({
    required Delivery delivery,
    required DeliveryState state,
  });

  /// Records that the recipient confirmed the pickup for the given [delivery].
  Future<bool> confirmPickup({
    required Delivery delivery,
  });

  /// Observes whether the backend has already moved the box counts of the
  /// delivery with the given [deliveryId] into the entity pair.
  Stream<bool> observeFoodBoxesTransferred({
    required String deliveryId,
  });

  /// Creates an empty food delivery in prepared state for the given [user].
  ///
  /// Returns `true` if the delivery was created successfully, `false` otherwise.
  /// If a delivery already exists for today, returns `true` without creating
  /// a new one.
  Future<bool> createFoodDelivery({
    required UserData user,
  });
}
