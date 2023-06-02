import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  final String internalId;
  final String email;
  // TODO password is not checked yet, change to final and add it to the functions below in the future
  String password = '';
  final String pickUpFrom;
  final String establishmentName;

  User({
    required this.internalId,
    required this.email,
    required this.pickUpFrom,
    required this.establishmentName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      internalId: json['id'],
      email: json['fields']['polozka3'],
      pickUpFrom: json['fields']['vyzvednoutOd'],
      establishmentName: json['fields']['nazevProvozovny'],
    );
  }

  factory User.create(
    String internalId,
    String email,
    String pickUpFrom,
    String establishmentName,
  ) {
    return User(
      internalId: internalId,
      email: email,
      pickUpFrom: pickUpFrom,
      establishmentName: establishmentName,
    );
  }
}
