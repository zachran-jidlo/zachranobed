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

  /// Checks if canteen could donate to the given [delivery]. The [time]
  /// parameter contains the start of the canteen's pickup window.
  bool canDonateFood({
    required Delivery delivery,
    required DateTime time,
  });
}
