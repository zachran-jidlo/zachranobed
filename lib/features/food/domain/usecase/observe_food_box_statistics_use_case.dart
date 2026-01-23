import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';

/// A use case for observing food box statistics.
class ObserveFoodBoxStatisticsUseCase {
  final FoodBoxRepository _repository;

  ObserveFoodBoxStatisticsUseCase(this._repository);

  /// Returns a stream of food box statistics for the given [user].
  Stream<Iterable<FoodBoxStatistics>> invoke(UserData user) {
    return _repository.observeStatistics(user);
  }
}
