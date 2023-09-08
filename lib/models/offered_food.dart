import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/converters/timestamp_converter.dart';

/*
 * Command to rebuild the offered_food.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'offered_food.freezed.dart';
part 'offered_food.g.dart';

@Freezed()
class OfferedFood with _$OfferedFood {
  const factory OfferedFood({
    String? id,
    @TimestampConverter() DateTime? date,
    int? dateTimestamp,
    String? dishName,
    String? foodCategory,
    List<String>? allergens,
    int? numberOfServings,
    String? boxType,
    @TimestampConverter() DateTime? consumeBy,
    int? consumeByTimestamp,
    String? weekNumber,
    String? donorId,
    String? recipientId,
    int? numberOfBoxes,
  }) = _OfferedFood;

  factory OfferedFood.fromJson(Map<String, dynamic> json) =>
      _$OfferedFoodFromJson(json);
}
