// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityDto _$EntityDtoFromJson(Map<String, dynamic> json) => EntityDto(
      id: json['id'] as String,
      email: json['email'] as String,
      establishmentName: json['establishmentName'] as String,
      establishmentId: json['establishmentId'] as String,
      organization: json['organization'] as String,
      responsiblePerson: json['responsiblePerson'] as String,
      phone: json['phone'] as String?,
      entityType: $enumDecodeNullable(
          _$EntityTypeDtoEnumMap, json['entityType'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      lastAcceptedAppTermsVersion:
          (json['lastAcceptedAppTermsVersion'] as num?)?.toInt(),
      additionalContacts: (json['additionalContacts'] as List<dynamic>?)
          ?.map((e) => ContactDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EntityDtoToJson(EntityDto instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'establishmentName': instance.establishmentName,
      'establishmentId': instance.establishmentId,
      'organization': instance.organization,
      'responsiblePerson': instance.responsiblePerson,
      'phone': instance.phone,
      'entityType': _$EntityTypeDtoEnumMap[instance.entityType],
      'lastAcceptedAppTermsVersion': instance.lastAcceptedAppTermsVersion,
      'additionalContacts': instance.additionalContacts,
    };

const _$EntityTypeDtoEnumMap = {
  EntityTypeDto.donor: 'DONOR',
  EntityTypeDto.recipient: 'RECIPIENT',
};
