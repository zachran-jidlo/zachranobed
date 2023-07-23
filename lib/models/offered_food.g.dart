// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offered_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferedFood _$OfferedFoodFromJson(Map<String, dynamic> json) => OfferedFood(
      id: json['id'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      foodInfo: FoodInfo.fromJson(json['foodInfo'] as Map<String, dynamic>),
      packaging: json['packaging'] as String,
      consumeBy:
          const TimestampConverter().fromJson(json['consumeBy'] as Timestamp),
      weekNumber: json['weekNumber'] as String,
      donor: json['donor'] as String,
      recipient: json['recipient'] as String,
    );

Map<String, dynamic> _$OfferedFoodToJson(OfferedFood instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': const TimestampConverter().toJson(instance.date),
      'foodInfo': instance.foodInfo.toJson(),
      'packaging': instance.packaging,
      'consumeBy': const TimestampConverter().toJson(instance.consumeBy),
      'weekNumber': instance.weekNumber,
      'donor': instance.donor,
      'recipient': instance.recipient,
    };
