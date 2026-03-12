import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the faq_category.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'faq_category.freezed.dart';

/// A grouping category for FAQ items.
@freezed
abstract class FaqCategory with _$FaqCategory {
  const factory FaqCategory({
    /// Unique identifier used to group FAQ items.
    required String id,

    /// Display title shown in the category list.
    required String title,

    /// Short description shown below the title in the category card.
    required String description,

    /// Sort order of the category in the list.
    required int order,
  }) = _FaqCategory;
}
