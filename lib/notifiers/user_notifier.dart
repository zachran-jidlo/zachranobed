import 'package:flutter/material.dart';
import 'package:zachranobed/models/user.dart';

class UserNotifier extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  set user(User? value) {
    _user = value;
    notifyListeners();
  }
}
