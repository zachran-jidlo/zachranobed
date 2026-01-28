import 'package:zachranobed/features/food/domain/model/offered_food.dart';
import 'package:zachranobed/features/food/domain/repository/offered_food_repository.dart';

/// A use case for observing meals in a specific delivery.
class ObserveDeliveryMealsUseCase {
  final OfferedFoodRepository _repository;

  ObserveDeliveryMealsUseCase(this._repository);

  /// Returns a stream of offered food items for the given [deliveryId].
  Stream<Iterable<OfferedFood>> invoke(String deliveryId) {
    return _repository.observeMealsForDelivery(deliveryId: deliveryId);
  }
}
