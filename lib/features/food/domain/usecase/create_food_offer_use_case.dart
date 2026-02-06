import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/repository/offered_food_repository.dart';

/// A use case for creating a food offer (donation) from a canteen to a charity.
class CreateFoodOfferUseCase {
  final OfferedFoodRepository _repository;

  CreateFoodOfferUseCase(this._repository);

  /// Creates a food offer for the given [delivery] with the specified [foodInfo]
  /// and [boxInfo] (map of food box type ID to count).
  ///
  /// Returns `true` if the offer was created successfully.
  Future<bool> invoke({
    required Delivery delivery,
    required List<FoodInfo> foodInfo,
    required Map<String, int> boxInfo,
  }) {
    return _repository.createOffer(
      delivery: delivery,
      foodInfo: foodInfo,
      boxInfo: boxInfo,
    );
  }
}
