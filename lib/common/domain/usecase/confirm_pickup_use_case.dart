import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';

/// Use case to record that the recipient confirmed the pickup of a delivery.
class ConfirmPickupUseCase {
  final DeliveryRepository _deliveryRepository;

  /// Creates a new instance of [ConfirmPickupUseCase].
  ConfirmPickupUseCase(this._deliveryRepository);

  /// Confirms the pickup for the given [delivery].
  ///
  /// Returns `true` if the confirmation was recorded successfully, `false`
  /// otherwise.
  Future<bool> invoke(Delivery delivery) {
    return _deliveryRepository.confirmPickup(delivery: delivery);
  }
}
