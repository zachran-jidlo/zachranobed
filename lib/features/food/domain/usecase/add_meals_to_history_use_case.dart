import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/repository/offered_food_repository.dart';

/// Records meals straight into history for the given [UserData], bypassing the
/// normal delivery process. Used by the manual donation entry flow.
class AddMealsToHistoryUseCase {
  final OfferedFoodRepository _repository;

  AddMealsToHistoryUseCase(this._repository);

  /// Saves [foodInfo] into today's manual delivery for the user's active pair.
  ///
  /// Returns `true` if the meals were recorded successfully.
  Future<bool> invoke({
    required UserData user,
    required List<FoodInfo> foodInfo,
  }) {
    return _repository.addMealsToHistory(
      user: user,
      foodInfo: foodInfo,
    );
  }
}
