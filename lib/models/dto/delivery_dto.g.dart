// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryDto _$DeliveryDtoFromJson(Map<String, dynamic> json) => DeliveryDto(
      donorId: json['donorId'] as String,
      recipientId: json['recipientId'] as String,
      deliveryDate: const TimestampConverter()
          .fromJson(json['deliveryDate'] as Timestamp),
      meals: (json['meals'] as List<dynamic>)
          .map((e) => MealDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      state: $enumDecodeNullable(_$DeliveryStateDtoEnumMap, json['state'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
    );

Map<String, dynamic> _$DeliveryDtoToJson(DeliveryDto instance) =>
    <String, dynamic>{
      'donorId': instance.donorId,
      'recipientId': instance.recipientId,
      'deliveryDate': const TimestampConverter().toJson(instance.deliveryDate),
      'meals': instance.meals,
      'state': instance.state,
    };

const _$DeliveryStateDtoEnumMap = {
  DeliveryStateDto.prepared: 'PREPARED',
  DeliveryStateDto.offered: 'OFFERED',
  DeliveryStateDto.accepted: 'ACCEPTED',
  DeliveryStateDto.inDelivery: 'IN_DELIVERY',
  DeliveryStateDto.delivered: 'DELIVERED',
  DeliveryStateDto.notUsed: 'NOT_USED',
};
