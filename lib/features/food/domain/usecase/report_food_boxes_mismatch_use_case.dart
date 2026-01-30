import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';

/// A use case for reporting a food boxes mismatch.
class ReportFoodBoxesMismatchUseCase {
  final FoodBoxRepository _repository;

  ReportFoodBoxesMismatchUseCase(this._repository);

  /// Reports a mismatch in the food boxes checkup for the given [user].
  ///
  /// Returns `true` if the report was successful, `false` otherwise.
  Future<bool> invoke(UserData user) {
    return _repository.reportFoodBoxesMismatch(user: user);
  }
}
