// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqCategoryDto _$FaqCategoryDtoFromJson(Map<String, dynamic> json) => FaqCategoryDto(
  title: json['title'] as String,
  description: json['description'] as String,
  order: (json['order'] as num).toInt(),
);

Map<String, dynamic> _$FaqCategoryDtoToJson(FaqCategoryDto instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'order': instance.order,
};
