import 'package:zachranobed/features/faq/domain/model/faq_item.dart';

/// Repository to observe FAQ items.
abstract class FaqRepository {
  /// Observes all FAQ items.
  Stream<List<FaqItem>> observeFaqItems();
}
