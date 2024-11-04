import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/enums/food_category.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_date_time.dart';

/*
 * Command to rebuild the food_info.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'food_info.freezed.dart';

@Freezed()
class FoodInfo with _$FoodInfo {
  const factory FoodInfo({
    required String id, // The UUID identifier
    String? dishName,
    List<String>? allergens,
    FoodCategory? foodCategory,
    int? foodTemperature,
    int? numberOfServings,
    int? numberOfBoxes,
    FoodBoxType? foodBoxType,
    FoodDateTime? preparedAt,
    FoodDateTime? consumeBy,
  }) = _FoodInfo;

  factory FoodInfo.withUuid({
    String? dishName,
    List<String>? allergens,
    FoodCategory? foodCategory,
    int? foodTemperature,
    int? numberOfServings,
    int? numberOfBoxes,
    FoodBoxType? foodBoxType,
    FoodDateTime? preparedAt,
    FoodDateTime? consumeBy,
  }) {
    return FoodInfo(
      id: const Uuid().v4(),
      // Generating the UUID for id
      dishName: dishName,
      allergens: allergens,
      foodCategory: foodCategory,
      foodTemperature: foodTemperature,
      numberOfServings: numberOfServings,
      numberOfBoxes: numberOfBoxes,
      foodBoxType: foodBoxType,
      preparedAt: preparedAt,
      consumeBy: consumeBy,
    );
  }
}

extension FoodInfoExtension on FoodInfo {
  /// Creates a copy of this [FoodInfo] object with the given [foodCategory] and
  /// updates the [preparedAt] field accordingly.
  ///
  /// If the [foodCategory] type is not [FoodCategoryType.cooled], the
  /// [preparedAt] field will be set to null. This is because the [preparedAt]
  /// field is only relevant for cooled food categories.
  ///
  /// Returns a new [FoodInfo] object with the updated values.
  FoodInfo copyWithFoodCategory(FoodCategory? foodCategory) {
    FoodDateTime? newPreparedAt = preparedAt;
    if (foodCategory?.type != FoodCategoryType.cooled) {
      newPreparedAt = null;
    }
    return copyWith(
      foodCategory: foodCategory,
      preparedAt: newPreparedAt,
    );
  }
}

extension FoodInfoListExtension on List<FoodInfo> {
  ///Extension on List<FoodInfo> to verify the available box count.
  Future<bool> verifyAvailableBoxCount(
      BuildContext context, FoodBoxRepository foodBoxRepository) async {
    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      return false;
    }

    final requiredBoxes = <String, int>{};
    for (final foodInfo in this) {
      final foodBoxId = foodInfo.foodBoxType?.id;
      if (foodBoxId == null) {
        continue;
      }
      final required = foodInfo.numberOfBoxes ?? foodInfo.numberOfServings ?? 0;
      requiredBoxes[foodBoxId] = (requiredBoxes[foodBoxId] ?? 0) + required;
    }

    final available = await foodBoxRepository.verifyAvailableBoxCount(
      user: user,
      requiredBoxes: requiredBoxes,
      getQuantity: (e) => e.quantityAtCanteen,
    );

    return available;
  }
}
