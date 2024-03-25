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
      foodBoxes: (json['foodBoxes'] as List<dynamic>)
          .map((e) => FoodBoxDeliveryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meals: (json['meals'] as List<dynamic>)
          .map((e) => MealDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      state: $enumDecodeNullable(_$DeliveryStateDtoEnumMap, json['state'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      type: $enumDecodeNullable(_$DeliveryTypeDtoEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
    );

Map<String, dynamic> _$DeliveryDtoToJson(DeliveryDto instance) =>
    <String, dynamic>{
      'donorId': instance.donorId,
      'recipientId': instance.recipientId,
      'deliveryDate': const TimestampConverter().toJson(instance.deliveryDate),
      'foodBoxes': instance.foodBoxes,
      'meals': instance.meals,
      'state': instance.state,
      'type': instance.type,
    };

const _$DeliveryStateDtoEnumMap = {
  DeliveryStateDto.prepared: 'PREPARED',
  DeliveryStateDto.offered: 'OFFERED',
  DeliveryStateDto.accepted: 'ACCEPTED',
  DeliveryStateDto.inDelivery: 'IN_DELIVERY',
  DeliveryStateDto.delivered: 'DELIVERED',
  DeliveryStateDto.notUsed: 'NOT_USED',
};

const _$DeliveryTypeDtoEnumMap = {
  DeliveryTypeDto.foodDelivery: 'FOOD_DELIVERY',
  DeliveryTypeDto.boxDelivery: 'BOX_DELIVERY',
};
