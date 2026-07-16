// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerDto _$BannerDtoFromJson(Map<String, dynamic> json) => BannerDto(
      id: json['id'] as String,
      active: json['active'] as bool?,
      priority: (json['priority'] as num?)?.toInt(),
      title: json['title'] as String?,
      text: json['text'] as String?,
      type: json['type'] as String?,
      validFrom: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['validFrom'], const TimestampConverter().fromJson),
      validTo: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['validTo'], const TimestampConverter().fromJson),
      role: json['role'] as String?,
      entityIds: (json['entityIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      platforms: (json['platforms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      minAppVersion: json['minAppVersion'] as String?,
      maxAppVersion: json['maxAppVersion'] as String?,
      closable: json['closable'] as bool?,
      actionLabel: json['actionLabel'] as String?,
      actionUrl: json['actionUrl'] as String?,
    );

Map<String, dynamic> _$BannerDtoToJson(BannerDto instance) => <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'priority': instance.priority,
      'title': instance.title,
      'text': instance.text,
      'type': instance.type,
      'validFrom': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.validFrom, const TimestampConverter().toJson),
      'validTo': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.validTo, const TimestampConverter().toJson),
      'role': instance.role,
      'entityIds': instance.entityIds,
      'tags': instance.tags,
      'platforms': instance.platforms,
      'minAppVersion': instance.minAppVersion,
      'maxAppVersion': instance.maxAppVersion,
      'closable': instance.closable,
      'actionLabel': instance.actionLabel,
      'actionUrl': instance.actionUrl,
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
