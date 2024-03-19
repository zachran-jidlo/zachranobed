// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_box_pair_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodBoxPairDto _$FoodBoxPairDtoFromJson(Map<String, dynamic> json) =>
    FoodBoxPairDto(
      foodBoxId: json['foodBoxId'] as String,
      count: json['count'] as int,
      donorCount: json['donorCount'] as int,
      recipientCount: json['recipientCount'] as int,
    );

Map<String, dynamic> _$FoodBoxPairDtoToJson(FoodBoxPairDto instance) =>
    <String, dynamic>{
      'foodBoxId': instance.foodBoxId,
      'count': instance.count,
      'donorCount': instance.donorCount,
      'recipientCount': instance.recipientCount,
    };
