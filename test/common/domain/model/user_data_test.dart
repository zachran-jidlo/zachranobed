import 'package:flutter_test/flutter_test.dart';
import 'package:zachranobed/common/domain/model/entity_pair.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup.dart';
import 'package:zachranobed/common/domain/model/local_time.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';

void main() {
  FoodBoxesCheckup checkup() {
    return FoodBoxesCheckup(
      status: FoodBoxesCheckupStatus.notNeeded,
      checkAt: DateTime(2025, 1, 1),
      verifiedAt: null,
      lastChange: FoodBoxesCheckupLastChange.admin,
    );
  }

  EntityPair pair(String recipientId, {required bool enabled}) {
    return EntityPair(
      donorId: 'donor',
      donorEstablishmentName: 'donor',
      recipientId: recipientId,
      recipientEstablishmentName: recipientId,
      carrierId: enabled ? 'dodo' : 'disabled',
      boxReturnCarrierId: 'personal',
      enabled: enabled,
      pickupTimeStart: LocalTime(hour: 10, minute: 0),
      pickupTimeEnd: LocalTime(hour: 11, minute: 0),
      deliveryTimeStart: LocalTime(hour: 12, minute: 0),
      deliveryTimeEnd: LocalTime(hour: 13, minute: 0),
      usesReturnableFoodBoxes: false,
      donorFoodBoxesCheckup: checkup(),
      recipientFoodBoxesCheckup: checkup(),
      donorManualDonationEnabled: false,
      recipientManualDonationEnabled: false,
      pickupConfirmationEnabled: false,
      confirmationTime: const Duration(minutes: 30),
    );
  }

  Canteen canteen(List<EntityPair> pairs) {
    return Canteen(
      entityId: 'donor',
      email: 'donor@example.com',
      establishmentName: 'donor',
      establishmentId: 'donor',
      organization: 'org',
      lastAcceptedAppTermsVersion: null,
      activePair: pairs.first,
      allPairs: pairs,
      tags: const [],
    );
  }

  test('account is inactive when no pair is active', () {
    final user = canteen([
      pair('a', enabled: false),
      pair('b', enabled: false),
    ]);

    expect(user.isAccountActive, isFalse);
    expect(user.enabledPairs, isEmpty);
  });

  test('account is active when at least one pair is active', () {
    final user = canteen([
      pair('a', enabled: false),
      pair('b', enabled: true),
    ]);

    expect(user.isAccountActive, isTrue);
    expect(user.enabledPairs.map((e) => e.recipientId), ['b']);
  });

  test('an inactive pair does not make the account a multi-pair one', () {
    final user = canteen([
      pair('a', enabled: true),
      pair('b', enabled: false),
    ]);

    expect(user.hasMultiplePairs, isFalse);
  });

  test('two active pairs make the account a multi-pair one', () {
    final user = canteen([
      pair('a', enabled: true),
      pair('b', enabled: true),
    ]);

    expect(user.hasMultiplePairs, isTrue);
  });
}
