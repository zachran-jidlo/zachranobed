import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zachranobed/common/data/dto/delivery_dto.dart';
import 'package:zachranobed/common/data/mapper/delivery_mapper.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';

void main() {
  DeliveryDto deliveryDto({required Map<String, dynamic> overrides}) {
    return DeliveryDto.fromJson({
      'id': 'delivery',
      'donorId': 'donor',
      'recipientId': 'recipient',
      'deliveryDate': Timestamp.fromDate(DateTime(2026, 1, 1)),
      'foodBoxes': <dynamic>[],
      'meals': <dynamic>[],
      'state': 'PREPARED',
      'type': 'FOOD_DELIVERY',
      'confirmationTime': 30,
      'foodBoxesTransferred': false,
      ...overrides,
    });
  }

  group('state mapping', () {
    test('maps every DTO state to its domain counterpart', () {
      const expected = {
        DeliveryStateDto.prepared: DeliveryState.prepared,
        DeliveryStateDto.accepted: DeliveryState.accepted,
        DeliveryStateDto.onWayToPickUp: DeliveryState.onWayToPickUp,
        DeliveryStateDto.inDelivery: DeliveryState.inDelivery,
        DeliveryStateDto.delivered: DeliveryState.delivered,
        DeliveryStateDto.done: DeliveryState.done,
        DeliveryStateDto.notUsed: DeliveryState.notUsed,
        DeliveryStateDto.interrupted: DeliveryState.interrupted,
      };

      expect(expected.length, DeliveryStateDto.values.length);
      for (final entry in expected.entries) {
        expect(entry.key.toDomain(), entry.value);
        expect(entry.value.toDto(), entry.key);
      }
    });

    test('parses INTERRUPTED from Firestore', () {
      final dto = deliveryDto(overrides: {'state': 'INTERRUPTED'});

      expect(dto.state, DeliveryStateDto.interrupted);
      expect(dto.toDomain()?.state, DeliveryState.interrupted);
    });

    test('drops a delivery whose state is unknown', () {
      final dto = deliveryDto(overrides: {'state': 'SOMETHING_NEW'});

      expect(dto.state, isNull);
      expect(dto.toDomain(), isNull);
    });
  });
}
