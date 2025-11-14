// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_contacts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigurationContactsDto _$ConfigurationContactsDtoFromJson(
        Map<String, dynamic> json) =>
    ConfigurationContactsDto(
      organisationContacts: (json['organisationContacts'] as List<dynamic>)
          .map((e) => ContactDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConfigurationContactsDtoToJson(
        ConfigurationContactsDto instance) =>
    <String, dynamic>{
      'organisationContacts': instance.organisationContacts,
    };
