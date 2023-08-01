// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      email: json['email'] as String,
      pickUpFrom: json['pickUpFrom'] as String,
      pickUpWithin: json['pickUpWithin'] as String,
      establishmentName: json['establishmentName'] as String,
      organization: json['organization'] as String,
      recipient: json['recipient'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'email': instance.email,
      'pickUpFrom': instance.pickUpFrom,
      'pickUpWithin': instance.pickUpWithin,
      'establishmentName': instance.establishmentName,
      'organization': instance.organization,
      'recipient': instance.recipient,
    };
