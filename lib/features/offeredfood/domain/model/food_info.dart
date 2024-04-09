import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the food_info.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'food_info.freezed.dart';

@Freezed()
class FoodInfo with _$FoodInfo {
  const factory FoodInfo({
    String? dishName,
    List<String>? allergens,
    String? foodCategory,
    int? numberOfServings,
    int? numberOfBoxes,
    String? foodBoxId,
    DateTime? consumeBy,
  }) = _FoodInfo;
}
