import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String internalId = '';
  String email = '';
  String password = '';
  String pickUpFrom = '';

  User.empty();

  User.newUser({
    required this.internalId,
    required this.email,
    required this.pickUpFrom,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User.newUser(
      internalId: json['id'],
      email: json['fields']['email'],
      pickUpFrom: json['fields']['vyzvednoutOd'],
    );
  }

  void newUser(String internalId, String email, String pickUpFrom) {
    this.internalId = internalId;
    this.email = email;
    this.pickUpFrom = pickUpFrom;
    notifyListeners();
  }
}
