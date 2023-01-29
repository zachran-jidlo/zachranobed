import 'package:flutter/material.dart';

class User extends ChangeNotifier {

  String id = "";
  String email = "";
  String password = "";

  User.empty();

  User.newUser({required this.id, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User.newUser(
      id: json['fields']['x_ID'],
      email: json['fields']['email'],
    );
  }

  void newUser(String id, String email) {
    this.id = id;
    this.email = email;
    notifyListeners();
  }
}
