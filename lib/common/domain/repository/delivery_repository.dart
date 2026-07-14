import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';

/// Repository for managing deliveries.
abstract class DeliveryRepository {
  /// Observes the current delivery for a given [user].
  Stream<Delivery?> observeCurrentDelivery({
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

  /// Creates an empty food delivery in prepared state for the given [user].
  ///
  /// Returns `true` if the delivery was created successfully, `false` otherwise.
  /// If a delivery already exists for today, returns `true` without creating
  /// a new one.
  Future<bool> createFoodDelivery({
    required UserData user,
  });
}
