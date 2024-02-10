// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offered_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferedFoodImpl _$$OfferedFoodImplFromJson(Map<String, dynamic> json) =>
    _$OfferedFoodImpl(
      id: json['id'] as String?,
      date: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['date'], const TimestampConverter().fromJson),
      dateTimestamp: json['dateTimestamp'] as int?,
      dishName: json['dishName'] as String?,
      foodCategory: json['foodCategory'] as String?,
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      numberOfServings: json['numberOfServings'] as int?,
      boxType: json['boxType'] as String?,
      consumeBy: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['consumeBy'], const TimestampConverter().fromJson),
      consumeByTimestamp: json['consumeByTimestamp'] as int?,
      weekNumber: json['weekNumber'] as String?,
      donorId: json['donorId'] as String?,
      recipientId: json['recipientId'] as String?,
      numberOfBoxes: json['numberOfBoxes'] as int?,
    );

Map<String, dynamic> _$$OfferedFoodImplToJson(_$OfferedFoodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.date, const TimestampConverter().toJson),
      'dateTimestamp': instance.dateTimestamp,
      'dishName': instance.dishName,
      'foodCategory': instance.foodCategory,
      'allergens': instance.allergens,
      'numberOfServings': instance.numberOfServings,
      'boxType': instance.boxType,
      'consumeBy': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.consumeBy, const TimestampConverter().toJson),
      'consumeByTimestamp': instance.consumeByTimestamp,
      'weekNumber': instance.weekNumber,
      'donorId': instance.donorId,
      'recipientId': instance.recipientId,
      'numberOfBoxes': instance.numberOfBoxes,
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
