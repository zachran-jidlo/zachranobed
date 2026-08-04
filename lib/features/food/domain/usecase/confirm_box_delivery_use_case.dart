import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';

/// Use case to confirm that the donor received a box return.
class ConfirmBoxDeliveryUseCase {
  /// How long to wait for a single update while the backend moves the counts.
  /// The wait resets on every update of the delivery, so a slow but progressing
  /// transfer is not cut short.
  static const _transferTimeout = Duration(seconds: 15);

  final DeliveryRepository _deliveryRepository;

  /// Creates a new instance of [ConfirmBoxDeliveryUseCase].
  ConfirmBoxDeliveryUseCase(this._deliveryRepository);

  /// Confirms the box return [delivery], which hands the boxes over to the donor
  /// right away instead of waiting for the carrier schedule.
  ///
  /// Returns only once the backend has moved the box counts, so the caller can
  /// keep the user waiting instead of dropping them on a screen with stale
  /// counts. Returns `true` if the confirmation was recorded, `false` otherwise.
  /// A transfer that does not land in time still counts as a success, because the
  /// confirmation itself is written and the counts follow on their own.
  Future<bool> invoke(Delivery delivery) async {
    final confirmed = await _deliveryRepository.confirmBoxDelivery(delivery: delivery);
    if (!confirmed) {
      return false;
    }

    await _awaitTransfer(delivery.id);
    return true;
  }

  Future<void> _awaitTransfer(String deliveryId) async {
    try {
      await _deliveryRepository
          .observeFoodBoxesTransferred(deliveryId: deliveryId)
          .timeout(_transferTimeout)
          .firstWhere((transferred) => transferred);
    } catch (_) {
      // Timed out, or the stream failed. The confirmation is already written, so
      // let the caller move on and the counts catch up when the backend is done.
    }
  }
}
