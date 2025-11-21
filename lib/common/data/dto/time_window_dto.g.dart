// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_window_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeWindowDto _$TimeWindowDtoFromJson(Map<String, dynamic> json) =>
    TimeWindowDto(
      start: json['start'] as String,
      end: json['end'] as String,
    );

Map<String, dynamic> _$TimeWindowDtoToJson(TimeWindowDto instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };
