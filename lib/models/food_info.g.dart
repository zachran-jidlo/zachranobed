// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodInfo _$FoodInfoFromJson(Map<String, dynamic> json) => FoodInfo(
      dishName: json['dishName'] as String? ?? '',
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      numberOfServings: json['numberOfServings'] as int?,
    );

Map<String, dynamic> _$FoodInfoToJson(FoodInfo instance) => <String, dynamic>{
      'dishName': instance.dishName,
      'allergens': instance.allergens,
      'numberOfServings': instance.numberOfServings,
    };
