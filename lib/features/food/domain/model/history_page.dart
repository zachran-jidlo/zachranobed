import 'package:zachranobed/common/domain/model/delivery_page_cursor.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';

/// A page of offered food history together with the cursor for the page that
/// follows it.
class HistoryPage {
  final List<OfferedFood> items;

  /// Cursor for the next page, or null when the last page has been reached.
  final DeliveryPageCursor? nextCursor;

  const HistoryPage({
    required this.items,
    required this.nextCursor,
  });
}
