import 'package:flutter/material.dart';

class User extends ChangeNotifier {

  String internalId = "";
  String email = "";
  String password = "";

  User.empty();

  User.newUser({required this.internalId, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User.newUser(
      internalId: json['id'],
      email: json['fields']['email'],
    );
  }

  void newUser(String internalId, String email) {
    this.internalId = internalId;
    this.email = email;
    notifyListeners();
  }
}
