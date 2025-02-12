import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/models/entity_pair.dart';
import 'package:zachranobed/models/food_boxes_checkup.dart';

abstract class UserData extends ChangeNotifier {
  final String entityId;
  final String email;
  final String establishmentName;
  final String establishmentId;
  final String organization;
  final int? lastAcceptedAppTermsVersion;
  final EntityPair activePair;
  final List<EntityPair> allPairs;

  UserData({
    required this.entityId,
    required this.email,
    required this.establishmentName,
    required this.establishmentId,
    required this.organization,
    required this.lastAcceptedAppTermsVersion,
    required this.activePair,
    required this.allPairs,
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

  /// Determines whether there are multiple pairs available.
  bool get hasMultiplePairs => allPairs.length > 1;

  /// Checks if any non-active pair requires a food boxes checkup.
  bool get isAnyNonActiveCheckupNeeded {
    return allPairs
        .whereNot((pair) => pair.donorId == activePair.donorId && pair.recipientId == activePair.recipientId)
        .any((pair) => getFoodBoxesCheckup(pair).isCheckupNeeded());
  }

  /// Creates a copy of this [UserData] object with a replaced [activePair].
  UserData copyWith({required EntityPair activePair});

  /// Return a relevant [FoodBoxesCheckup] for current user.
  FoodBoxesCheckup getFoodBoxesCheckup(EntityPair pair);
}
