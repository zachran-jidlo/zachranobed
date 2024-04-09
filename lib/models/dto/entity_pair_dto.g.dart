// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_pair_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityPairDto _$EntityPairDtoFromJson(Map<String, dynamic> json) =>
    EntityPairDto(
      donorId: json['donorId'] as String,
      recipientId: json['recipientId'] as String,
      pickupTimeWindows: (json['pickupTimeWindows'] as List<dynamic>)
          .map((e) => TimeWindowDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      foodboxes: (json['foodboxes'] as List<dynamic>)
          .map((e) => FoodBoxPairDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EntityPairDtoToJson(EntityPairDto instance) =>
    <String, dynamic>{
      'donorId': instance.donorId,
      'recipientId': instance.recipientId,
      'pickupTimeWindows': instance.pickupTimeWindows,
      'foodboxes': instance.foodboxes,
    };
