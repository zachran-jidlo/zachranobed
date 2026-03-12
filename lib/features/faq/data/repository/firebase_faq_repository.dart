import 'package:rxdart/rxdart.dart';
import 'package:zachranobed/features/faq/data/mapper/faq_mapper.dart';
import 'package:zachranobed/features/faq/data/service/faq_service.dart';
import 'package:zachranobed/features/faq/domain/model/faq_item.dart';
import 'package:zachranobed/features/faq/domain/repository/faq_repository.dart';

/// Implementation of the [FaqRepository] via Firebase services.
class FirebaseFaqRepository implements FaqRepository {
  final FaqService _faqService;

  FirebaseFaqRepository(this._faqService);

  @override
  Stream<List<FaqItem>> observeFaqItems() {
    return CombineLatestStream.combine2(
      _faqService.observeFaqCategories(),
      _faqService.observeFaqItems(),
      (categoryDocs, itemDocs) {
        // Build a lookup map: categoryId -> FaqCategory
        final categoryMap = {
          for (final doc in categoryDocs) doc.id: doc.data().toDomain(doc.id),
        };

        // Map each item DTO to domain, resolving its category via the lookup
        final items = itemDocs.map((doc) {
          final dto = doc.data();
          final category = dto.categoryId != null ? categoryMap[dto.categoryId] : null;
          return dto.toDomain(doc.id, category: category);
        }).toList();

        // Sort by category order first, then by item order within each category
        items.sort((a, b) {
          final categoryOrder = (a.category?.order ?? 0).compareTo(b.category?.order ?? 0);
          if (categoryOrder != 0) {
            return categoryOrder;
          }
          return a.order.compareTo(b.order);
        });

        return items;
      },
    );
  }
}
