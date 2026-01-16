import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';
import 'package:zachranobed/features/food/domain/repository/offered_food_repository.dart';

/// A use case for fetching paginated offered food history.
class GetHistoryPaginatedUseCase {
  static const int _pageSize = 20;

  final OfferedFoodRepository _repository;

  GetHistoryPaginatedUseCase(this._repository);

  /// Fetches a page of offered food history for the given [user].
  ///
  /// Use [startAfterDate] to fetch items after the last delivery date from the previous page.
  Future<Iterable<OfferedFood>> invoke({
    required UserData user,
    DateTime? startAfterDate,
  }) {
    return _repository.getHistoryPaginated(
      user: user,
      limit: _pageSize,
      startAfterDate: startAfterDate,
    );
  }
}
