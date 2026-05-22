import 'package:collection/collection.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';

/// A use case for verifying available box count.
class VerifyAvailableBoxCountUseCase {
  final FoodBoxRepository _repository;

  VerifyAvailableBoxCountUseCase(this._repository);

  /// Checks if entity with the given [user] has at least [requiredBoxes] count. The [requiredBoxes] map contains keys
  /// with box IDs and values for count of required boxes.
  ///
  /// Returns `true` if the user has enough boxes, `false` otherwise.
  Future<bool> invoke({
    required UserData user,
    required Map<String, int> requiredBoxes,
  }) async {
    int Function(FoodBoxStatistics?) getQuantity = switch (user) {
      Canteen() => (statistics) => statistics?.availableQuantityAtCanteen ?? 0,
      Charity() => (statistics) => statistics?.availableQuantityAtCharity ?? 0,
    };

    final statistics = await _repository.observeStatistics(user).first;
    final statisticsMap = {for (final s in statistics) s.type.id: s};

    final disposableBoxId = _repository.getDisposableBoxId();
    final requiredBoxesEntries = requiredBoxes.entries.whereNot((item) => item.key == disposableBoxId);

    for (final item in requiredBoxesEntries) {
      final required = item.value;
      final available = getQuantity(statisticsMap[item.key]);

      if (available < required) {
        return false;
      }
    }

    return true;
  }
}
