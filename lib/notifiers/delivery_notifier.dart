import 'package:flutter/cupertino.dart';
import 'package:zachranobed/models/delivery.dart';

class DeliveryNotifier extends ChangeNotifier {
  Delivery? _delivery;

  Delivery? get delivery => _delivery;

  set delivery(Delivery? value) {
    _delivery = value;
    notifyListeners();
  }
}
