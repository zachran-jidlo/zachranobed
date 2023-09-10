// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_of_boxes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ShippingOfBoxes _$$_ShippingOfBoxesFromJson(Map<String, dynamic> json) =>
    _$_ShippingOfBoxes(
      charityId: json['charityId'] as String?,
      canteenId: json['canteenId'] as String?,
      date: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['date'], const TimestampConverter().fromJson),
    );

Map<String, dynamic> _$$_ShippingOfBoxesToJson(_$_ShippingOfBoxes instance) =>
    <String, dynamic>{
      'charityId': instance.charityId,
      'canteenId': instance.canteenId,
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
