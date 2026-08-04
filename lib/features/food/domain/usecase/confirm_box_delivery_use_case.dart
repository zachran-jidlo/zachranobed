import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';

/// Use case to confirm that the donor received a box return.
class ConfirmBoxDeliveryUseCase {
  final DeliveryRepository _deliveryRepository;

  /// Creates a new instance of [ConfirmBoxDeliveryUseCase].
  ConfirmBoxDeliveryUseCase(this._deliveryRepository);

  /// Confirms the box return [delivery], which hands the boxes over to the donor
  /// right away instead of waiting for the carrier schedule.
  ///
  /// Returns `true` if the confirmation was recorded successfully, `false`
  /// otherwise.
  Future<bool> invoke(Delivery delivery) {
    return _deliveryRepository.confirmBoxDelivery(delivery: delivery);
  }
}
