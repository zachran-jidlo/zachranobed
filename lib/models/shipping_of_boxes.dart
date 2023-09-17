import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/converters/timestamp_converter.dart';

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
    @TimestampConverter() DateTime? date,
  }) = _ShippingOfBoxes;

  factory ShippingOfBoxes.fromJson(Map<String, dynamic> json) =>
      _$ShippingOfBoxesFromJson(json);
}
