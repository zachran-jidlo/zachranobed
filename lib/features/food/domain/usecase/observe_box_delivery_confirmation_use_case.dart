import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';
import 'package:zachranobed/features/food/domain/model/box_delivery_confirmation.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';

/// A use case for observing a box return that the canteen can confirm today.
class ObserveBoxDeliveryConfirmationUseCase {
  final DeliveryRepository _deliveryRepository;
  final FoodBoxRepository _foodBoxRepository;

  ObserveBoxDeliveryConfirmationUseCase(
    this._deliveryRepository,
    this._foodBoxRepository,
  );

  /// Returns a stream of the box returns [user] can confirm right now, or null
  /// when there is nothing to confirm.
  ///
  /// Returns that land on the same day are merged into one confirmation, so the
  /// canteen sees a single total and confirms all of them together.
  Stream<BoxDeliveryConfirmation?> invoke(UserData user) async* {
    // Prefetch types once so they are not fetched again on every stream event.
    // Types come back in display order, so iterating them keeps the summary in
    // the same order as the box tiles.
    final types = await _foodBoxRepository.getTypes();

    yield* _deliveryRepository.observeCurrentBoxDeliveries(user: user).map((deliveries) {
      final confirmable = deliveries.where((delivery) => delivery.isBoxDeliveryConfirmationActive(user)).toList();
      if (confirmable.isEmpty) {
        return null;
      }

      final items = <BoxDeliveryConfirmationItem>[];
      for (final type in types) {
        final count = confirmable.fold(0, (sum, delivery) => sum + (delivery.foodBoxes[type.id] ?? 0));
        if (count <= 0) {
          // Not part of these returns
          continue;
        }
        items.add(BoxDeliveryConfirmationItem(type: type, count: count));
      }

      if (items.isEmpty) {
        return null;
      }

      return BoxDeliveryConfirmation(deliveries: confirmable, items: items);
    });
  }
}
