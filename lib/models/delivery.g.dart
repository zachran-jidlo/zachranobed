// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryImpl _$$DeliveryImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryImpl(
      id: json['id'] as String,
      donorId: json['donorId'] as String,
      recipientId: json['recipientId'] as String,
      state: $enumDecode(_$DeliveryStateEnumMap, json['state']),
      type: $enumDecode(_$DeliveryTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$DeliveryImplToJson(_$DeliveryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'donorId': instance.donorId,
      'recipientId': instance.recipientId,
      'state': _$DeliveryStateEnumMap[instance.state]!,
      'type': _$DeliveryTypeEnumMap[instance.type]!,
    };

const _$DeliveryStateEnumMap = {
  DeliveryState.prepared: 'prepared',
  DeliveryState.offered: 'offered',
  DeliveryState.accepted: 'accepted',
  DeliveryState.inDelivery: 'inDelivery',
  DeliveryState.delivered: 'delivered',
  DeliveryState.notUsed: 'notUsed',
};

const _$DeliveryTypeEnumMap = {
  DeliveryType.foodDelivery: 'foodDelivery',
  DeliveryType.boxDelivery: 'boxDelivery',
};
