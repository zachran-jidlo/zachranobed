// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Charity _$CharityFromJson(Map<String, dynamic> json) => Charity(
      email: json['email'] as String,
      establishmentName: json['establishmentName'] as String,
      establishmentId: json['establishmentId'] as String,
      organization: json['organization'] as String,
      donorId:
          (json['donorId'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CharityToJson(Charity instance) => <String, dynamic>{
      'email': instance.email,
      'establishmentName': instance.establishmentName,
      'establishmentId': instance.establishmentId,
      'organization': instance.organization,
      'donorId': instance.donorId,
    };
