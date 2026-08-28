// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_pair_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityPairDto _$EntityPairDtoFromJson(Map<String, dynamic> json) => EntityPairDto(
  donorId: json['donorId'] as String,
  recipientId: json['recipientId'] as String,
  carrierId: json['carrierId'] as String,
  boxReturnCarrierId: json['boxReturnCarrierId'] as String,
  pickupTimeWindows: (json['pickupTimeWindows'] as List<dynamic>)
      .map((e) => TimeWindowDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  deliveryTimeWindows: (json['deliveryTimeWindows'] as List<dynamic>)
      .map((e) => TimeWindowDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  foodboxes: (json['foodboxes'] as List<dynamic>)
      .map((e) => FoodBoxPairDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  foodboxesCheckup: json['foodboxesCheckup'] == null
      ? null
      : FoodBoxesCheckupSummaryDto.fromJson(json['foodboxesCheckup'] as Map<String, dynamic>),
  manualDonation: json['manualDonation'] == null
      ? null
      : ManualDonationSummaryDto.fromJson(json['manualDonation'] as Map<String, dynamic>),
  pickupConfirmation: json['pickupConfirmation'] == null
      ? null
      : PickupConfirmationDto.fromJson(json['pickupConfirmation'] as Map<String, dynamic>),
  confirmationTime: (json['confirmationTime'] as num).toInt(),
);

Map<String, dynamic> _$EntityPairDtoToJson(EntityPairDto instance) => <String, dynamic>{
  'donorId': instance.donorId,
  'recipientId': instance.recipientId,
  'carrierId': instance.carrierId,
  'boxReturnCarrierId': instance.boxReturnCarrierId,
  'pickupTimeWindows': instance.pickupTimeWindows,
  'deliveryTimeWindows': instance.deliveryTimeWindows,
  'foodboxes': instance.foodboxes,
  'foodboxesCheckup': instance.foodboxesCheckup,
  'manualDonation': instance.manualDonation,
  'pickupConfirmation': instance.pickupConfirmation,
  'confirmationTime': instance.confirmationTime,
};
