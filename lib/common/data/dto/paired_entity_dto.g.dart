// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paired_entity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PairedEntityDto _$PairedEntityDtoFromJson(Map<String, dynamic> json) => PairedEntityDto(
  id: json['id'] as String,
  establishmentName: json['establishmentName'] as String,
  responsiblePerson: json['responsiblePerson'] as String,
  responsiblePersonPosition: json['responsiblePersonPosition'] as String?,
  phone: json['phone'] as String?,
  additionalContacts: (json['additionalContacts'] as List<dynamic>?)
      ?.map((e) => ContactDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PairedEntityDtoToJson(PairedEntityDto instance) => <String, dynamic>{
  'id': instance.id,
  'establishmentName': instance.establishmentName,
  'responsiblePerson': instance.responsiblePerson,
  'responsiblePersonPosition': instance.responsiblePersonPosition,
  'phone': instance.phone,
  'additionalContacts': instance.additionalContacts,
};
