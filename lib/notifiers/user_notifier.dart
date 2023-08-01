import 'package:flutter/material.dart';
import 'package:zachranobed/models/user_data.dart';

class UserNotifier extends ChangeNotifier {
  UserData? _user;

  UserData? get user => _user;

  set user(UserData? value) {
    _user = value;
    notifyListeners();
  }
}
