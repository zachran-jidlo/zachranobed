import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/features/faq/domain/model/faq_category.dart';

/*
 * Command to rebuild the faq_item.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'faq_item.freezed.dart';

/// Represents a single FAQ entry.
///
/// The optional [category] groups items under a shared heading. When multiple
/// distinct categories exist the UI shows a category list first. Otherwise
/// the questions are displayed directly.
@freezed
abstract class FaqItem with _$FaqItem {
  const factory FaqItem({
    /// Firestore document ID.
    required String id,

    /// The question text displayed in the list.
    required String question,

    /// Full answer text.
    required String answer,

    /// Sort order within a category (or globally when no categories exist).
    required int order,

    /// Optional category this item belongs to.
    FaqCategory? category,
  }) = _FaqItem;
}
