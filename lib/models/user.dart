import 'package:flutter/material.dart';

class User extends ChangeNotifier {

  String _email = "";
  String _password = "";

  /*User(this.email, this.password) {
    notifyListeners();
  }*/

  String get email => _email;

  set email(String email) {
    _email = email;
    notifyListeners();
  }

}