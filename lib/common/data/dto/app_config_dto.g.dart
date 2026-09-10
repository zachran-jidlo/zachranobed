// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigDto _$AppConfigDtoFromJson(Map<String, dynamic> json) => AppConfigDto(
      minimumAppVersion: json['minimumAppVersion'] as String,
      latestAppVersion: json['latestAppVersion'] as String? ?? '0.0.0',
    );

Map<String, dynamic> _$AppConfigDtoToJson(AppConfigDto instance) => <String, dynamic>{
      'minimumAppVersion': instance.minimumAppVersion,
      'latestAppVersion': instance.latestAppVersion,
    };
