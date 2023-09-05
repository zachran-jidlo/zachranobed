// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canteen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Canteen _$CanteenFromJson(Map<String, dynamic> json) => Canteen(
      email: json['email'] as String,
      establishmentName: json['establishmentName'] as String,
      establishmentId: json['establishmentId'] as String,
      organization: json['organization'] as String,
      pickUpFrom: json['pickUpFrom'] as String?,
      pickUpWithin: json['pickUpWithin'] as String?,
      recipient: json['recipient'] == null
          ? null
          : Charity.fromJson(json['recipient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CanteenToJson(Canteen instance) => <String, dynamic>{
      'email': instance.email,
      'establishmentName': instance.establishmentName,
      'establishmentId': instance.establishmentId,
      'organization': instance.organization,
      'pickUpFrom': instance.pickUpFrom,
      'pickUpWithin': instance.pickUpWithin,
      'recipient': instance.recipient,
    };
