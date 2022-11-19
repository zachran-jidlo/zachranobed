import 'package:flutter/material.dart';

class User extends ChangeNotifier {

  String email = "";
  String password = "";

  /*User(this.email, this.password) {
    notifyListeners();
  }*/

  void newUser(String email, String password) {
    this.email = email;
    this.password = password;
    notifyListeners();
  }

}