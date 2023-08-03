import 'package:flutter/material.dart';
import 'package:zachranobed/models/donor.dart';
import 'package:zachranobed/models/recipient.dart';

class UserNotifier extends ChangeNotifier {
  dynamic _user;

  dynamic get user => _user;

  set user(dynamic value) {
    if (value is Donor || value is Recipient) {
      _user = value;
      notifyListeners();
    } else {
      throw ArgumentError.value(value);
    }
  }
}
