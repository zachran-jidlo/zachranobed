import 'package:zachranobed/features/faq/data/dto/faq_category_dto.dart';
import 'package:zachranobed/features/faq/data/dto/faq_item_dto.dart';
import 'package:zachranobed/features/faq/domain/model/faq_category.dart';
import 'package:zachranobed/features/faq/domain/model/faq_item.dart';

/// DTO to domain mapper for [FaqCategory].
extension FaqCategoryMapper on FaqCategoryDto {
  /// Maps DTO to domain representation.
  FaqCategory toDomain() {
    return FaqCategory(
      id: id,
      title: title,
      description: description,
    );
  }
}

/// DTO to domain mapper for [FaqItem].
extension FaqItemMapper on FaqItemDto {
  /// Maps DTO to domain representation.
  FaqItem toDomain(String id) {
    return FaqItem(
      id: id,
      question: question,
      answer: answer,
      order: order,
      category: category?.toDomain(),
    );
  }
}
