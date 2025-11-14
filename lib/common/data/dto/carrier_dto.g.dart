// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrier_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarrierDto _$CarrierDtoFromJson(Map<String, dynamic> json) => CarrierDto(
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => ContactDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CarrierDtoToJson(CarrierDto instance) =>
    <String, dynamic>{
      'contacts': instance.contacts,
    };
