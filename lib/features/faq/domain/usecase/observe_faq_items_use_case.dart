import 'package:zachranobed/features/faq/domain/model/faq_item.dart';
import 'package:zachranobed/features/faq/domain/repository/faq_repository.dart';

/// A use case for observing FAQ items.
class ObserveFaqItemsUseCase {
  final FaqRepository _repository;

  ObserveFaqItemsUseCase(this._repository);

  /// Observes all FAQ items.
  Stream<List<FaqItem>> invoke() {
    return _repository.observeFaqItems();
  }
}
