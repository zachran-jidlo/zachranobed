// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealDto _$MealDtoFromJson(Map<String, dynamic> json) => MealDto(
      mealId: json['mealId'] as String,
      count: (json['count'] as num?)?.toInt(),
      packagesCount: (json['packagesCount'] as num?)?.toInt(),
      preparedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['preparedAt'], const TimestampConverter().fromJson),
      consumeBy: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['consumeBy'], const TimestampConverter().fromJson),
      foodTemperature: (json['foodTemperature'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MealDtoToJson(MealDto instance) => <String, dynamic>{
      'mealId': instance.mealId,
      'count': instance.count,
      'packagesCount': instance.packagesCount,
      'preparedAt': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.preparedAt, const TimestampConverter().toJson),
      'consumeBy': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.consumeBy, const TimestampConverter().toJson),
      'foodTemperature': instance.foodTemperature,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
