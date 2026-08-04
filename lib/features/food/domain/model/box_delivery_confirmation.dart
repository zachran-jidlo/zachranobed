import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/features/food/domain/model/food_box_type.dart';

/// A box return the canteen can confirm as received, with its box ids already
/// resolved to types.
///
/// Carries the [delivery] so confirming does not need to look it up again.
class BoxDeliveryConfirmation {
  /// The box return delivery to confirm.
  final Delivery delivery;

  /// Box types and counts the charity sent back, in display order.
  final List<BoxDeliveryConfirmationItem> items;

  const BoxDeliveryConfirmation({
    required this.delivery,
    required this.items,
  });

  /// Total number of boxes across all types.
  int get totalCount => items.fold(0, (sum, item) => sum + item.count);
}

/// A single box type and how many of it the charity sent back.
class BoxDeliveryConfirmationItem {
  /// The box type.
  final FoodBoxType type;

  /// Number of boxes of this type.
  final int count;

  const BoxDeliveryConfirmationItem({
    required this.type,
    required this.count,
  });
}
