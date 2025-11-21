// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_pair_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityPairDto _$EntityPairDtoFromJson(Map<String, dynamic> json) =>
    EntityPairDto(
      donorId: json['donorId'] as String,
      recipientId: json['recipientId'] as String,
      carrierId: json['carrierId'] as String,
      pickupTimeWindows: (json['pickupTimeWindows'] as List<dynamic>)
          .map((e) => TimeWindowDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      foodboxes: (json['foodboxes'] as List<dynamic>)
          .map((e) => FoodBoxPairDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      foodboxesCheckup: json['foodboxesCheckup'] == null
          ? null
          : FoodBoxesCheckupSummaryDto.fromJson(
              json['foodboxesCheckup'] as Map<String, dynamic>),
      confirmationTime: (json['confirmationTime'] as num).toInt(),
    );

Map<String, dynamic> _$EntityPairDtoToJson(EntityPairDto instance) =>
    <String, dynamic>{
      'donorId': instance.donorId,
      'recipientId': instance.recipientId,
      'carrierId': instance.carrierId,
      'pickupTimeWindows': instance.pickupTimeWindows,
      'foodboxes': instance.foodboxes,
      'foodboxesCheckup': instance.foodboxesCheckup,
      'confirmationTime': instance.confirmationTime,
    };
