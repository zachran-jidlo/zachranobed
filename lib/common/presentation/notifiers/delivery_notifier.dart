import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';
import 'package:zachranobed/common/domain/usecase/confirm_pickup_use_case.dart';

class DeliveryNotifier extends ChangeNotifier {
  final DeliveryRepository _repository;
  final ConfirmPickupUseCase _confirmPickupUseCase;
  Delivery? _delivery;

  DeliveryNotifier(this._repository, this._confirmPickupUseCase);

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

  /// Records that the recipient confirmed the pickup of the current delivery.
  ///
  /// Optimistically updates the local delivery so the UI reacts immediately,
  /// then persists the confirmation.
  Future<void> confirmPickup() async {
    final currentDelivery = _delivery;
    _delivery = currentDelivery?.copyWith(isPickupConfirmed: true);
    notifyListeners();

    if (currentDelivery != null) {
      await _confirmPickupUseCase.invoke(currentDelivery);
    }
  }

  /// Cancels the active delivery subscription and clears delivery state.
  ///
  /// Call this on user logout to prevent Firestore permission-denied errors
  /// caused by an active listener running after the auth session ends.
  void reset() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _delivery = null;
    notifyListeners();
  }

  /// Inform listeners about the change.
  void refreshDelivery() {
    // Only update UI listeners, so that "canDonate" flag is reevaluated
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
