import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  final String internalId;
  final String email;
  // TODO password is not checked yet, change to final and add it to the functions below in the future
  String password = '';
  final String pickUpFrom;
  final String pickUpWithin;
  final String establishmentName;
  final String organization;
  final String recipient;

  User({
    required this.internalId,
    required this.email,
    required this.pickUpFrom,
    required this.pickUpWithin,
    required this.establishmentName,
    required this.organization,
    required this.recipient,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      internalId: json['id'],
      email: json['fields']['email'],
      pickUpFrom: json['fields']['vyzvednoutOd'],
      pickUpWithin: json['fields']['vyzvednoutDo'],
      establishmentName: json['fields']['nazevProvozovny'],
      organization: json['fields']['zastresujiciOrganizace'],
      recipient: json['fields']['prijemce']['fields']['nazevProvozovny'],
    );
  }

  factory User.create(
    String internalId,
    String email,
    String pickUpFrom,
    String pickUpWithin,
    String establishmentName,
    String organization,
    String recipient,
  ) {
    return User(
      internalId: internalId,
      email: email,
      pickUpFrom: pickUpFrom,
      pickUpWithin: pickUpWithin,
      establishmentName: establishmentName,
      organization: organization,
      recipient: recipient,
    );
  }
}
