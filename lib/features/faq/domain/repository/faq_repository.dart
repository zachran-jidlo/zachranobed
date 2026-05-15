import 'package:zachranobed/features/faq/domain/model/faq_item.dart';

/// Repository to observe FAQ data.
abstract class FaqRepository {
  /// Observes all FAQ items with resolved categories.
  Stream<List<FaqItem>> observeFaqItems();
}
