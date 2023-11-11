import 'package:flutter/cupertino.dart';
import 'package:zachranobed/enums/delivery_state.dart';
import 'package:zachranobed/models/delivery.dart';

class DeliveryNotifier extends ChangeNotifier {
  Delivery? _delivery;

  Delivery? get delivery => _delivery;

  set delivery(Delivery? value) {
    _delivery = value;
    notifyListeners();
  }

  void updateDeliveryState(String state) {
    _delivery = _delivery!.copyWith(state: state);
    notifyListeners();
  }

  bool deliveryConfirmed(BuildContext context) {
    return _delivery?.state ==
        DeliveryStateHelper.toValue(DeliveryState.confirmed, context);
  }

  bool deliveryCancelled(BuildContext context) {
    return _delivery?.state ==
        DeliveryStateHelper.toValue(DeliveryState.canceled, context);
  }
}
