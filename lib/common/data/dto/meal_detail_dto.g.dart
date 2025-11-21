// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealDetailDto _$MealDetailDtoFromJson(Map<String, dynamic> json) =>
    MealDetailDto(
      id: json['id'] as String,
      name: json['name'] as String,
      donorId: json['donorId'] as String,
      foodCategory: json['foodCategory'] as String,
      foodCategoryType: json['foodCategoryType'] as String?,
      allergens:
          (json['allergens'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MealDetailDtoToJson(MealDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'donorId': instance.donorId,
      'foodCategory': instance.foodCategory,
      'foodCategoryType': instance.foodCategoryType,
      'allergens': instance.allergens,
    };
