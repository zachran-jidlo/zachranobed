// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealDto _$MealDtoFromJson(Map<String, dynamic> json) => MealDto(
      mealId: json['mealId'] as String,
      count: (json['count'] as num).toInt(),
      consumeBy:
          const TimestampConverter().fromJson(json['consumeBy'] as Timestamp),
      foodBoxId: json['foodBoxId'] as String,
      foodBoxCount: (json['foodBoxCount'] as num).toInt(),
    );

Map<String, dynamic> _$MealDtoToJson(MealDto instance) => <String, dynamic>{
      'mealId': instance.mealId,
      'count': instance.count,
      'consumeBy': const TimestampConverter().toJson(instance.consumeBy),
      'foodBoxId': instance.foodBoxId,
      'foodBoxCount': instance.foodBoxCount,
    };
