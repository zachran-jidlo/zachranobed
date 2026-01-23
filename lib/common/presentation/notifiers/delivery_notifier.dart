import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:zachranobed/common/domain/model/canteen.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';

class DeliveryNotifier extends ChangeNotifier {
  final DeliveryRepository _repository;
  Delivery? _delivery;

  DeliveryNotifier(this._repository);

  Delivery? get delivery => _delivery;

  /// A subscription to the stream of deliveries.
  StreamSubscription<Delivery?>? _streamSubscription;

  void init(UserData user) async {
    observeDelivery(user);
  }

  /// Observes the current delivery.
  ///
  /// This method subscribes to the stream of deliveries from the repository and
  /// updates the current delivery whenever a new delivery is emitted.
  void observeDelivery(UserData user) {
    _streamSubscription?.cancel();
    _streamSubscription = _repository.observeCurrentDelivery(user: user).listen((delivery) async {
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

  /// Inform listeners about the change.
  void refreshDelivery() {
    // Only update UI listeners, so that "canDonate" flag is reevaluated
    notifyListeners();
  }

  bool canDonate(UserData user) {
    if (user is! Canteen) {
      return false;
    }

    final currentDelivery = _delivery;
    if (currentDelivery == null) {
      return false;
    }

    // User is updated before the delivery, so we should check if delivery matches the current active pair
    if (currentDelivery.recipientId != user.activePair.recipientId) {
      return false;
    }

    final time = DateTimeUtils.getDateTimeOfCurrentDelivery(user.pickUpFrom);
    return _repository.canDonateFood(
      delivery: currentDelivery,
      time: time,
    );
  }
}
