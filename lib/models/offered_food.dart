import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/converters/timestamp_converter.dart';
import 'package:zachranobed/models/food_info.dart';

/*
 * Command to rebuild the user_data.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'offered_food.g.dart';

@JsonSerializable(explicitToJson: true)
class OfferedFood {
  final String id;
  @TimestampConverter()
  final DateTime date;
  final FoodInfo foodInfo;
  final String packaging;
  @TimestampConverter()
  final DateTime consumeBy;
  final String weekNumber;
  final String donor;

  OfferedFood({
    required this.id,
    required this.date,
    required this.foodInfo,
    required this.packaging,
    required this.consumeBy,
    required this.weekNumber,
    required this.donor,
  });

  factory OfferedFood.fromJson(Map<String, dynamic> json) =>
      _$OfferedFoodFromJson(json);

  Map<String, dynamic> toJson() => _$OfferedFoodToJson(this);
}
