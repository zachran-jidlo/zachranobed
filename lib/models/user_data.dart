import 'package:flutter/material.dart';

abstract class UserData extends ChangeNotifier {
  final String email;
  final String establishmentName;
  final String establishmentId;
  final String organization;

  UserData({
    required this.email,
    required this.establishmentName,
    required this.establishmentId,
    required this.organization,
  });

  String get debugInfo {
    return 'Email: $email, Establishment: $establishmentName, ID: $establishmentId, Organization: $organization';
  }
}
