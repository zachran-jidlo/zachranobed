import 'package:flutter/material.dart';
import 'package:zachranobed/models/entity_pair.dart';

abstract class UserData extends ChangeNotifier {
  final String entityId;
  final String email;
  final String establishmentName;
  final String establishmentId;
  final String organization;
  final int? lastAcceptedAppTermsVersion;
  final EntityPair activePair;
  final bool hasMultiplePairs;

  UserData({
    required this.entityId,
    required this.email,
    required this.establishmentName,
    required this.establishmentId,
    required this.organization,
    required this.lastAcceptedAppTermsVersion,
    required this.activePair,
    required this.hasMultiplePairs,
  });

  String get debugInfo {
    return '''
      EntityID: $entityId, 
      Email: $email,
      Establishment: $establishmentName,
      ID: $establishmentId,
      Organization: $organization,
      Last accepted app terms version: $lastAcceptedAppTermsVersion,
      Active pair: ${activePair.donorId} <-> ${activePair.recipientId},
      Has multiple pairs: $hasMultiplePairs
    ''';
  }

  /// Creates a copy of this [UserData] object with a replaced [activePair].
  UserData copyWith({required EntityPair activePair});
}
