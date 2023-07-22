import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            AppLocalizations.of(context)!.deliveryConfirmedState
        ? true
        : false;
  }

  bool deliveryCancelled(BuildContext context) {
    return _delivery?.state ==
            AppLocalizations.of(context)!.deliveryCancelledState
        ? true
        : false;
  }
}
