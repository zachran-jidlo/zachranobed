// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqItemDto _$FaqItemDtoFromJson(Map<String, dynamic> json) => FaqItemDto(
      question: json['question'] as String,
      answer: json['answer'] as String,
      order: (json['order'] as num).toInt(),
      categoryId: json['categoryId'] as String?,
    );

Map<String, dynamic> _$FaqItemDtoToJson(FaqItemDto instance) => <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
      'order': instance.order,
      'categoryId': instance.categoryId,
    };
