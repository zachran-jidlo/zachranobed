// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqCategoryDto _$FaqCategoryDtoFromJson(Map<String, dynamic> json) =>
    FaqCategoryDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$FaqCategoryDtoToJson(FaqCategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
    };
