import 'package:flutter/cupertino.dart';
import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/user_data.dart';

class DeliveryNotifier extends ChangeNotifier {
  final OfferedFoodRepository _repository;
  Delivery? _delivery;

  DeliveryNotifier(this._repository);

  Delivery? get delivery => _delivery;

  void init(UserData user) async {
    if (user is! Canteen) {
      return;
    }

    final delivery = await _repository.getCurrentDelivery(
      entityId: user.entityId,
      time: DateTimeUtils.getDateTimeOfCurrentDelivery(user.pickUpFrom),
    );
    _delivery = delivery;
    notifyListeners();
  }

  /// Modifies the state of the current [Delivery] instance by creating a new
  /// instance with the specified [state], and then triggers a notification to
  /// inform listeners about the change.
  Future<void> updateDeliveryState(DeliveryState state) async {
    final currentDelivery = _delivery;
    _delivery = currentDelivery?.copyWith(state: state);
    notifyListeners();

    if (currentDelivery != null) {
      await _repository.updateDeliveryState(
        delivery: currentDelivery,
        state: state,
      );
    }
  }

  bool canDonate(UserData user) {
    if (user is! Canteen) {
      return false;
    }

    final currentDelivery = _delivery;
    if (currentDelivery == null) {
      return false;
    }

    final time = DateTimeUtils.getDateTimeOfCurrentDelivery(user.pickUpFrom);
    return _repository.canDonateFood(
      delivery: currentDelivery,
      time: time,
    );
  }
}
