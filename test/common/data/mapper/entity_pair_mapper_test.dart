import 'package:flutter_test/flutter_test.dart';
import 'package:zachranobed/common/data/dto/paired_entity_dto.dart';
import 'package:zachranobed/common/data/dto/entity_pair_dto.dart';
import 'package:zachranobed/common/data/dto/time_window_dto.dart';
import 'package:zachranobed/common/data/mapper/entity_pair_mapper.dart';

void main() {
  EntityPairDto pairDto({
    required String carrierId,
    required String boxReturnCarrierId,
  }) {
    return EntityPairDto(
      donorId: 'donor',
      recipientId: 'recipient',
      carrierId: carrierId,
      boxReturnCarrierId: boxReturnCarrierId,
      pickupTimeWindows: [TimeWindowDto(start: '10:00', end: '11:00')],
      deliveryTimeWindows: [TimeWindowDto(start: '12:00', end: '13:00')],
      foodboxes: [],
      foodboxesCheckup: null,
      manualDonation: null,
      pickupConfirmation: null,
      confirmationTime: 30,
    );
  }

  PairedEntityDto entityDto(String id) {
    return PairedEntityDto(
      id: id,
      establishmentName: id,
      responsiblePerson: 'person',
      responsiblePersonPosition: null,
      phone: null,
      additionalContacts: null,
    );
  }

  group('enabled', () {
    test('is true when both carriers are set', () {
      final dto = pairDto(carrierId: 'dodo', boxReturnCarrierId: 'personal');

      expect(dto.enabled, isTrue);
    });

    test('is false when the delivery carrier is disabled', () {
      final dto = pairDto(carrierId: 'disabled', boxReturnCarrierId: 'personal');

      expect(dto.enabled, isFalse);
    });

    test('is false when the box return carrier is disabled', () {
      final dto = pairDto(carrierId: 'dodo', boxReturnCarrierId: 'disabled');

      expect(dto.enabled, isFalse);
    });

    test('is carried over to the domain model', () {
      final pair = pairDto(carrierId: 'disabled', boxReturnCarrierId: 'disabled').toDomain(
        donor: entityDto('donor'),
        recipient: entityDto('recipient'),
      );

      expect(pair?.enabled, isFalse);
    });
  });
}
