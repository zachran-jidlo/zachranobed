import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/converters/timestamp_converter.dart';

/*
 * Command to rebuild the meal_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'meal_dto.g.dart';

@JsonSerializable()
class MealDto {
  final String mealId;
  final int count;
  @TimestampConverter()
  final DateTime? consumeBy;
  final String foodBoxId;
  final int foodBoxCount;

  MealDto({
    required this.mealId,
    required this.count,
    required this.consumeBy,
    required this.foodBoxId,
    required this.foodBoxCount,
  });

  factory MealDto.fromJson(Map<String, dynamic> json) =>
      _$MealDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MealDtoToJson(this);
}
