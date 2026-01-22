import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';

/// Use case to create an empty food delivery in prepared state.
class CreateFoodDeliveryUseCase {
  final DeliveryRepository _deliveryRepository;

  /// Creates a new instance of [CreateFoodDeliveryUseCase].
  CreateFoodDeliveryUseCase(this._deliveryRepository);

  /// Creates an empty food delivery in prepared state for the given [user].
  ///
  /// Returns `true` if the delivery was created successfully or already exists,
  /// `false` otherwise.
  Future<bool> invoke(UserData user) {
    return _deliveryRepository.createFoodDelivery(user: user);
  }
}
