// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BoxMovement _$$_BoxMovementFromJson(Map<String, dynamic> json) =>
    _$_BoxMovement(
      senderId: json['senderId'] as String?,
      recipientId: json['recipientId'] as String?,
      boxType: json['boxType'] as String?,
      numberOfBoxes: json['numberOfBoxes'] as int?,
      weekNumber: json['weekNumber'] as String?,
      date: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['date'], const TimestampConverter().fromJson),
    );

Map<String, dynamic> _$$_BoxMovementToJson(_$_BoxMovement instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'recipientId': instance.recipientId,
      'boxType': instance.boxType,
      'numberOfBoxes': instance.numberOfBoxes,
      'weekNumber': instance.weekNumber,
      'date': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.date, const TimestampConverter().toJson),
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
