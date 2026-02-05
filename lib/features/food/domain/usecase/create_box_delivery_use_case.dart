import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';

/// A use case for creating a box delivery from a charity to its paired canteen.
class CreateBoxDeliveryUseCase {
  final FoodBoxRepository _repository;

  CreateBoxDeliveryUseCase(this._repository);

  /// Creates a box delivery for the given [charity] with the specified
  /// [boxesQuantity] (map of food box type ID to count).
  ///
  /// Returns `true` if the delivery was created successfully.
  Future<bool> invoke({
    required Charity charity,
    required Map<String, int> boxesQuantity,
  }) {
    return _repository.createBoxDelivery(
      user: charity,
      boxesQuantity: boxesQuantity,
    );
  }
}
