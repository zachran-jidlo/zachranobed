import 'package:collection/collection.dart';
import 'package:zachranobed/common/domain/model/carrier_type.dart';
import 'package:zachranobed/common/domain/model/entity_pair.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup.dart';
import 'package:zachranobed/common/domain/model/local_time.dart';

part 'canteen.dart';
part 'charity.dart';

sealed class UserData {
  final String entityId;
  final String email;
  final String establishmentName;
  final String establishmentId;
  final String organization;
  final int? lastAcceptedAppTermsVersion;
  final EntityPair activePair;
  final List<EntityPair> allPairs;

  /// Free-form labels used for targeting.
  final List<String> tags;

  UserData({
    required this.entityId,
    required this.email,
    required this.establishmentName,
    required this.establishmentId,
    required this.organization,
    required this.lastAcceptedAppTermsVersion,
    required this.activePair,
    required this.allPairs,
    required this.tags,
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
      Has multiple pairs: $hasMultiplePairs,
      Account active: $isAccountActive,
      Manual donation enabled: $manualDonationEnabled,
      Tags: $tags,
    ''';
  }

  /// The pairs the user can actually work with.
  List<EntityPair> get enabledPairs => allPairs.where((pair) => pair.enabled).toList();

  /// Whether at least one pair of this account is turned on.
  ///
  /// An account with every pair turned off exists but cannot be used until an
  /// admin enables a pair.
  bool get isAccountActive => enabledPairs.isNotEmpty;

  /// Determines whether there are multiple pairs available.
  bool get hasMultiplePairs => enabledPairs.length > 1;

  /// Checks if any non-active pair requires a food boxes checkup.
  bool get isAnyNonActiveCheckupNeeded {
    return enabledPairs
        .whereNot((pair) => pair.donorId == activePair.donorId && pair.recipientId == activePair.recipientId)
        .any((pair) => getFoodBoxesCheckup(pair).isCheckupNeeded());
  }

  /// Creates a copy of this [UserData] object with a replaced [activePair].
  UserData copyWith({required EntityPair activePair});

  /// Return a relevant [FoodBoxesCheckup] for current user.
  FoodBoxesCheckup getFoodBoxesCheckup(EntityPair pair);

  /// Whether manual donation entry is enabled for the given [pair] and this
  /// user's role (donor for a canteen, recipient for a charity).
  bool isManualDonationEnabled(EntityPair pair);

  /// Whether manual donation entry is enabled for the current [activePair].
  bool get manualDonationEnabled => isManualDonationEnabled(activePair);

  /// Whether this user can confirm box returns of the current [activePair] as
  /// received. Only the canteen takes boxes back, and only when the charity
  /// brings them itself.
  bool get canConfirmBoxDeliveries {
    return this is Canteen && activePair.boxReturnCarrierId == CarrierType.personal.id;
  }
}
