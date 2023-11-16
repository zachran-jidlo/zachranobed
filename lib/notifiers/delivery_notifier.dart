import 'package:flutter/cupertino.dart';
import 'package:zachranobed/enums/delivery_state.dart';
import 'package:zachranobed/models/delivery.dart';

class DeliveryNotifier extends ChangeNotifier {
  Delivery? _delivery;

  Delivery? get delivery => _delivery;

  /// Sets the value of the [Delivery] instance to the provided [value], then
  /// triggers a notification to inform listeners about the change.
  set delivery(Delivery? value) {
    _delivery = value;
    notifyListeners();
  }

  /// Modifies the state of the current [Delivery] instance by creating a new
  /// instance with the specified [state], and then triggers a notification to
  /// inform listeners about the change.
  void updateDeliveryState(String state) {
    _delivery = _delivery!.copyWith(state: state);
    notifyListeners();
  }

  /// Checks if the current delivery is in the 'confirmed' state.
  ///
  /// Returns `true` if the delivery is confirmed, and `false` otherwise.
  bool isDeliveryConfirmed(BuildContext context) {
    return _delivery?.state ==
        DeliveryStateHelper.toValue(DeliveryState.confirmed, context);
  }

  /// Checks if the current delivery is in the 'canceled' state.
  ///
  /// Returns `true` if the delivery is canceled, and `false` otherwise.
  bool isDeliveryCancelled(BuildContext context) {
    return _delivery?.state ==
        DeliveryStateHelper.toValue(DeliveryState.canceled, context);
  }
}
