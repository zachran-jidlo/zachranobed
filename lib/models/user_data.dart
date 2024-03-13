import 'package:flutter/material.dart';

abstract class UserData extends ChangeNotifier {
  final String entityId;
  final String email;
  final String establishmentName;
  final String establishmentId;
  final String organization;

  UserData({
    required this.entityId,
    required this.email,
    required this.establishmentName,
    required this.establishmentId,
    required this.organization,
  });

  String get debugInfo {
    return 'EntityID: $entityId, Email: $email, Establishment: $establishmentName, ID: $establishmentId, Organization: $organization';
  }
}
