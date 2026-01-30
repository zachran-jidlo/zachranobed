import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';

/// A use case for delaying food boxes checkup.
class DelayFoodBoxesCheckupUseCase {
  final FoodBoxRepository _repository;

  DelayFoodBoxesCheckupUseCase(this._repository);

  /// Delays the food boxes checkup for the given [user].
  ///
  /// Returns `true` if the delay was successful, `false` otherwise.
  Future<bool> invoke(UserData user) {
    return _repository.delayFoodBoxesCheckup(user: user);
  }
}
