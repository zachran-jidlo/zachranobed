import 'package:zachranobed/features/food/domain/model/food_box_type.dart';

/// Statistics for a single food box type within a donor–recipient pair.
///
/// Counts are split into three categories:
/// - **At canteen / at charity** — boxes physically held by each side
///   (stored in the EntityPair `donorCount` / `recipientCount`).
/// - **On the way** — boxes in active deliveries that haven't reached
///   `delivered` state yet. Derived from delivery documents, not stored
///   in EntityPair.
///
/// Invariant: [totalQuantity] == [quantityAtCanteen] + [quantityAtCharity].
class FoodBoxStatistics {
  /// The box type these statistics belong to.
  final FoodBoxType type;

  /// Total number of boxes of this type across both sides.
  final int totalQuantity;

  /// Boxes currently held by the charity (recipient).
  final int quantityAtCharity;

  /// Boxes currently held by the canteen (donor).
  final int quantityAtCanteen;

  /// Boxes in active food deliveries heading from canteen to charity.
  final int quantityOnTheWayToCharity;

  /// Boxes in active box return deliveries heading from charity to canteen.
  final int quantityOnTheWayToCanteen;

  const FoodBoxStatistics({
    required this.type,
    required this.totalQuantity,
    required this.quantityAtCharity,
    required this.quantityAtCanteen,
    required this.quantityOnTheWayToCharity,
    required this.quantityOnTheWayToCanteen,
  });

  /// Boxes the charity can use — excludes those already on the way back.
  int get availableQuantityAtCharity =>
      quantityAtCharity - quantityOnTheWayToCanteen;

  /// Boxes the canteen can use — excludes those already on the way out.
  int get availableQuantityAtCanteen =>
      quantityAtCanteen - quantityOnTheWayToCharity;

  /// Total boxes currently in transit in either direction.
  int get quantityOnTheWay =>
      quantityOnTheWayToCharity + quantityOnTheWayToCanteen;
}
