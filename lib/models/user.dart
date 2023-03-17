import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  final String internalId;
  final String email;
  // TODO password is not checked yet, change to final and add it to the functions below in the future
  String password = '';
  final String pickUpFrom;

  User({
    required this.internalId,
    required this.email,
    required this.pickUpFrom,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      internalId: json['id'],
      email: json['fields']['email'],
      pickUpFrom: json['fields']['vyzvednoutOd'],
    );
  }

  factory User.create(String internalId, String email, String pickUpFrom) {
    return User(internalId: internalId, email: email, pickUpFrom: pickUpFrom);
  }
}
