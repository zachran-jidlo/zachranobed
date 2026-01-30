import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';

/// A use case for verifying food boxes checkup.
class VerifyFoodBoxesCheckupUseCase {
  final FoodBoxRepository _repository;

  VerifyFoodBoxesCheckupUseCase(this._repository);

  /// Verifies the food boxes checkup for the given [user].
  ///
  /// Returns `true` if the verification was successful, `false` otherwise.
  Future<bool> invoke(UserData user) {
    return _repository.verifyFoodBoxesCheckup(user: user);
  }
}
