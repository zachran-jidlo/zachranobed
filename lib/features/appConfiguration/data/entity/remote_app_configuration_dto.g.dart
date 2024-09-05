// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_app_configuration_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteAppConfigurationDto _$RemoteAppConfigurationDtoFromJson(
        Map<String, dynamic> json) =>
    RemoteAppConfigurationDto(
      lastAppTermsVersion: (json['lastAppTermsVersion'] as num).toInt(),
    );

Map<String, dynamic> _$RemoteAppConfigurationDtoToJson(
        RemoteAppConfigurationDto instance) =>
    <String, dynamic>{
      'lastAppTermsVersion': instance.lastAppTermsVersion,
    };
