import 'package:zachranobed/common/domain/model/delivery_page_cursor.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/model/history_page.dart';
import 'package:zachranobed/features/food/domain/repository/offered_food_repository.dart';

/// A use case for fetching paginated offered food history.
class GetHistoryPaginatedUseCase {
  static const int _pageSize = 20;

  final OfferedFoodRepository _repository;

  GetHistoryPaginatedUseCase(this._repository);

  /// Fetches a page of offered food history for the given [user].
  ///
  /// Pass the [HistoryPage.nextCursor] from the previous page as [startAfter] to
  /// load the following page. Pass null for the first page.
  Future<HistoryPage> invoke({
    required UserData user,
    DeliveryPageCursor? startAfter,
  }) {
    return _repository.getHistoryPaginated(
      user: user,
      limit: _pageSize,
      startAfter: startAfter,
    );
  }
}
