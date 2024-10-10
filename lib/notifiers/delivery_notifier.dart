import 'dart:async';

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

  /// A subscription to the stream of deliveries.
  StreamSubscription<Delivery?>? _streamSubscription;

  void init(UserData user) async {
    if (user is! Canteen) {
      return;
    }
    observeDelivery(user);
  }

  /// Observes the deliveries for a Canteen.
  ///
  /// This method subscribes to the stream of deliveries from the repository and
  /// updates the current delivery whenever a new delivery is emitted.
  ///
  /// The [canteen] parameter must not be null.
  void observeDelivery(Canteen canteen) {
    _streamSubscription?.cancel();
    _streamSubscription = _repository
        .observeCurrentDelivery(user: canteen)
        .listen((delivery) async {
      _delivery = delivery;
      notifyListeners();
    });
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

  /// Cancels current delivery if it is in prepared state and then triggers a
  /// notification to inform listeners about the change.
  Future<void> cancelCurrentDelivery() async {
    final currentDelivery = _delivery;
    if (currentDelivery == null) {
      return;
    }

    if (await _repository.cancelDelivery(delivery: currentDelivery)) {
      _delivery = currentDelivery.copyWith(state: DeliveryState.notUsed);
      notifyListeners();
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
