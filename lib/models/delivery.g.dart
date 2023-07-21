// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
      id: json['id'] as String,
      donor: json['donor'] as String,
      state: json['state'] as String,
    );

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      'id': instance.id,
      'donor': instance.donor,
      'state': instance.state,
    };
