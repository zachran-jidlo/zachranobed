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
    return _faqService.observeFaqItems().map(
      (docs) {
        return docs.map((doc) => doc.data().toDomain(doc.id)).toList();
      },
    );
  }
}
