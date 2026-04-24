import 'package:zachranobed/common/domain/model/food_boxes_checkup_reported_count.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';

/// A use case for reporting a food boxes mismatch.
class ReportFoodBoxesMismatchUseCase {
  final FoodBoxRepository _repository;

  ReportFoodBoxesMismatchUseCase(this._repository);

  /// Reports a mismatch in the food boxes checkup for the given [user].
  ///
  /// [reports] must contain one entry per food-box type, pairing the count
  /// the user observed with the count the system had recorded.
  ///
  /// Returns `true` if the report was successful, `false` otherwise.
  Future<bool> invoke(
    UserData user, {
    required List<FoodBoxesCheckupReportedCount> reports,
  }) {
    return _repository.reportFoodBoxesMismatch(user: user, reports: reports);
  }
}
