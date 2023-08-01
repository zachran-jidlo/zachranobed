import 'package:flutter/cupertino.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
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
    return _delivery?.state == context.l10n!.deliveryConfirmedState;
  }

  bool deliveryCancelled(BuildContext context) {
    return _delivery?.state == context.l10n!.deliveryCancelledState;
  }
}
