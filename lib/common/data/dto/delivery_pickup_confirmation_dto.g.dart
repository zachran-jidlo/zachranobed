// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_pickup_confirmation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryPickupConfirmationDto _$DeliveryPickupConfirmationDtoFromJson(
  Map<String, dynamic> json,
) => DeliveryPickupConfirmationDto(
  pickupConfirmedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['pickupConfirmedAt'],
    const TimestampConverter().fromJson,
  ),
);

Map<String, dynamic> _$DeliveryPickupConfirmationDtoToJson(
  DeliveryPickupConfirmationDto instance,
) => <String, dynamic>{
  'pickupConfirmedAt': ?_$JsonConverterToJson<Timestamp, DateTime>(
    instance.pickupConfirmedAt,
    const TimestampConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

Map<String, dynamic> _$DeliveryPickupConfirmationUpdateDtoToJson(
  DeliveryPickupConfirmationUpdateDto instance,
) => <String, dynamic>{
  'pickupConfirmation': ?instance.pickupConfirmation?.toJson(),
};
