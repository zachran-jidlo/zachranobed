import 'package:flutter/cupertino.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/shared/constants.dart';

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

  bool deliveryConfirmed() {
    return _delivery!.state == ZachranObedStrings.deliveryConfirmedState
        ? true
        : false;
  }
}
