// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_boxes_checkup_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodBoxesCheckupSummaryDto _$FoodBoxesCheckupSummaryDtoFromJson(
        Map<String, dynamic> json) =>
    FoodBoxesCheckupSummaryDto(
      donor: json['donor'] == null
          ? null
          : FoodBoxesCheckupDto.fromJson(json['donor'] as Map<String, dynamic>),
      recipient: json['recipient'] == null
          ? null
          : FoodBoxesCheckupDto.fromJson(
              json['recipient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FoodBoxesCheckupSummaryDtoToJson(
        FoodBoxesCheckupSummaryDto instance) =>
    <String, dynamic>{
      'donor': instance.donor,
      'recipient': instance.recipient,
    };

FoodBoxesCheckupDto _$FoodBoxesCheckupDtoFromJson(Map<String, dynamic> json) =>
    FoodBoxesCheckupDto(
      status: $enumDecodeNullable(
          _$FoodBoxesCheckupStatusDtoEnumMap, json['status']),
      checkAt:
          const TimestampConverter().fromJson(json['checkAt'] as Timestamp),
      verifiedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['verifiedAt'], const TimestampConverter().fromJson),
      lastChange: $enumDecodeNullable(
          _$FoodBoxesCheckupLastChangeDtoEnumMap, json['lastChange']),
    );

Map<String, dynamic> _$FoodBoxesCheckupDtoToJson(
        FoodBoxesCheckupDto instance) =>
    <String, dynamic>{
      'status': instance.status?.toJson(),
      'checkAt': const TimestampConverter().toJson(instance.checkAt),
      'verifiedAt': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.verifiedAt, const TimestampConverter().toJson),
      'lastChange': instance.lastChange?.toJson(),
    };

const _$FoodBoxesCheckupStatusDtoEnumMap = {
  FoodBoxesCheckupStatusDto.ok: 'OK',
  FoodBoxesCheckupStatusDto.delayed: 'DELAYED',
  FoodBoxesCheckupStatusDto.mismatch: 'MISMATCH',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$FoodBoxesCheckupLastChangeDtoEnumMap = {
  FoodBoxesCheckupLastChangeDto.user: 'USER',
  FoodBoxesCheckupLastChangeDto.admin: 'ADMIN',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
