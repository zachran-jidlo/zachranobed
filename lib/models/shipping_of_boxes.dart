import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the shipping_of_boxes.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'shipping_of_boxes.freezed.dart';
part 'shipping_of_boxes.g.dart';

@Freezed()
class ShippingOfBoxes with _$ShippingOfBoxes {
  const factory ShippingOfBoxes({
    String? charityId,
    String? canteenId,
    String? boxType,
    int? numberOfBoxes,
  }) = _ShippingOfBoxes;

  factory ShippingOfBoxes.fromJson(Map<String, dynamic> json) =>
      _$ShippingOfBoxesFromJson(json);
}
