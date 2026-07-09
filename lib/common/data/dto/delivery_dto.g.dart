// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryDto _$DeliveryDtoFromJson(Map<String, dynamic> json) => DeliveryDto(
      id: json['id'] as String,
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
      confirmationTime: (json['confirmationTime'] as num?)?.toInt(),
      foodBoxesTransferred: json['foodBoxesTransferred'] as bool?,
      manualDonation: json['manualDonation'] as bool?,
    );

Map<String, dynamic> _$DeliveryDtoToJson(DeliveryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'donorId': instance.donorId,
      'recipientId': instance.recipientId,
      'deliveryDate': const TimestampConverter().toJson(instance.deliveryDate),
      'foodBoxes': instance.foodBoxes.map((e) => e.toJson()).toList(),
      'meals': instance.meals.map((e) => e.toJson()).toList(),
      'state': instance.state?.toJson(),
      'type': instance.type?.toJson(),
      'confirmationTime': instance.confirmationTime,
      if (instance.foodBoxesTransferred case final value?)
        'foodBoxesTransferred': value,
      if (instance.manualDonation case final value?) 'manualDonation': value,
    };

const _$DeliveryStateDtoEnumMap = {
  DeliveryStateDto.prepared: 'PREPARED',
  DeliveryStateDto.accepted: 'ACCEPTED',
  DeliveryStateDto.onWayToPickUp: 'ON_WAY_TO_PICK_UP',
  DeliveryStateDto.inDelivery: 'IN_DELIVERY',
  DeliveryStateDto.delivered: 'DELIVERED',
  DeliveryStateDto.done: 'DONE',
  DeliveryStateDto.notUsed: 'NOT_USED',
};

const _$DeliveryTypeDtoEnumMap = {
  DeliveryTypeDto.foodDelivery: 'FOOD_DELIVERY',
  DeliveryTypeDto.boxDelivery: 'BOX_DELIVERY',
};
