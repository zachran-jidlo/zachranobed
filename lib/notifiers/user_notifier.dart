import 'package:flutter/material.dart';
import 'package:zachranobed/models/user_data.dart';

class UserNotifier extends ChangeNotifier {
  UserData? _user;

  UserData? get user => _user;

  /// Sets the value of the [UserData] instance to the provided [value], then
  /// triggers a notification to inform listeners about the change.
  set user(UserData? value) {
    _user = value;
    notifyListeners();
  }
}
