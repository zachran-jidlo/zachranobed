import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';

/// Repository for managing deliveries.
abstract class DeliveryRepository {
  /// Observes the current delivery for a given [user].
  Stream<Delivery?> observeCurrentDelivery({
    required UserData user,
  });

  /// Observes today's box return for a given [user], or null when there is none.
  Stream<Delivery?> observeCurrentBoxDelivery({
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

  /// Confirms that the donor received the box return [delivery], which moves the
  /// box counts to the donor without waiting for the carrier schedule.
  Future<bool> confirmBoxDelivery({
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
