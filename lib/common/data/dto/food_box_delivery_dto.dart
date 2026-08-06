import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the food_box_delivery_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'food_box_delivery_dto.g.dart';

@JsonSerializable()
class FoodBoxDeliveryDto {
  final String foodBoxId;
  final int count;

  FoodBoxDeliveryDto({
    required this.foodBoxId,
    required this.count,
  });

  factory FoodBoxDeliveryDto.fromJson(Map<String, dynamic> json) => _$FoodBoxDeliveryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FoodBoxDeliveryDtoToJson(this);
}

/// Utilities for the food box lists stored on a delivery document.
extension FoodBoxDeliveryListUtils on Iterable<FoodBoxDeliveryDto> {
  /// Sums counts per food box id.
  Map<String, int> toCountMap() => <String, int>{}..addCounts(this);
}

/// Utilities for maps of food box id to count.
extension FoodBoxCountMapUtils on Map<String, int> {
  /// Adds the counts of [boxes] on top of the counts already in this map. A
  /// document may repeat the same food box id, so entries are accumulated
  /// instead of overwritten.
  void addCounts(Iterable<FoodBoxDeliveryDto> boxes) {
    for (final box in boxes) {
      this[box.foodBoxId] = (this[box.foodBoxId] ?? 0) + box.count;
    }
  }
}
