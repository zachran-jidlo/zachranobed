// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_suggestion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealSuggestionDto _$MealSuggestionDtoFromJson(Map<String, dynamic> json) =>
    MealSuggestionDto(
      id: json['id'] as String,
      name: json['name'] as String,
      allergens:
          (json['allergens'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MealSuggestionDtoToJson(MealSuggestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'allergens': instance.allergens,
    };
