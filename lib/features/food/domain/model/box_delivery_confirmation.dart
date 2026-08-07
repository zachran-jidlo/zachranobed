import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/features/food/domain/model/food_box_type.dart';

/// The box returns the canteen can confirm as received, with their box ids
/// already resolved to types.
///
/// Carries the [deliveries] so confirming does not need to look them up again.
/// A single day can hold more than one return, so the counts of all of them are
/// merged into one list the canteen confirms at once.
class BoxDeliveryConfirmation {
  /// The box return deliveries to confirm.
  final List<Delivery> deliveries;

  /// Box types and counts the charity sent back, in display order. Counts are
  /// summed across all [deliveries].
  final List<BoxDeliveryConfirmationItem> items;

  const BoxDeliveryConfirmation({
    required this.deliveries,
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
