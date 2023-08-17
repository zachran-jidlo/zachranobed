// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Donor _$DonorFromJson(Map<String, dynamic> json) => Donor(
      email: json['email'] as String,
      pickUpFrom: json['pickUpFrom'] as String?,
      pickUpWithin: json['pickUpWithin'] as String?,
      establishmentName: json['establishmentName'] as String,
      establishmentId: json['establishmentId'] as String,
      organization: json['organization'] as String,
      recipient: json['recipient'] == null
          ? null
          : Recipient.fromJson(json['recipient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DonorToJson(Donor instance) => <String, dynamic>{
      'email': instance.email,
      'pickUpFrom': instance.pickUpFrom,
      'pickUpWithin': instance.pickUpWithin,
      'establishmentName': instance.establishmentName,
      'establishmentId': instance.establishmentId,
      'organization': instance.organization,
      'recipient': instance.recipient,
    };
