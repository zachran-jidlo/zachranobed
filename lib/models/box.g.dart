// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Box _$BoxFromJson(Map<String, dynamic> json) => Box(
      charityId: json['charityId'] as String,
      canteenId: json['canteenId'] as String,
      boxType: json['boxType'] as String,
      totalQuantity: json['totalQuantity'] as int,
      quantityAtCharity: json['quantityAtCharity'] as int,
      quantityAtCanteen: json['quantityAtCanteen'] as int,
    );

Map<String, dynamic> _$BoxToJson(Box instance) => <String, dynamic>{
      'charityId': instance.charityId,
      'canteenId': instance.canteenId,
      'boxType': instance.boxType,
      'totalQuantity': instance.totalQuantity,
      'quantityAtCharity': instance.quantityAtCharity,
      'quantityAtCanteen': instance.quantityAtCanteen,
    };
