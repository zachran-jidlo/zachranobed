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
      donor: json['donor'] == null
          ? null
          : Canteen.fromJson(json['donor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharityToJson(Charity instance) => <String, dynamic>{
      'email': instance.email,
      'establishmentName': instance.establishmentName,
      'establishmentId': instance.establishmentId,
      'organization': instance.organization,
      'donor': instance.donor,
    };
