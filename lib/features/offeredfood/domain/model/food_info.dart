import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:zachranobed/common/helper_service.dart';
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
    String? foodCategory,
    int? numberOfServings,
    int? numberOfBoxes,
    String? foodBoxId,
    FoodDateTime? consumeBy,
  }) = _FoodInfo;

  factory FoodInfo.withUuid({
    String? dishName,
    List<String>? allergens,
    String? foodCategory,
    int? numberOfServings,
    int? numberOfBoxes,
    String? foodBoxId,
    FoodDateTime? consumeBy,
  }) {
    return FoodInfo(
      id: const Uuid().v4(),
      // Generating the UUID for id
      dishName: dishName,
      allergens: allergens,
      foodCategory: foodCategory,
      numberOfServings: numberOfServings,
      numberOfBoxes: numberOfBoxes,
      foodBoxId: foodBoxId,
      consumeBy: consumeBy,
    );
  }
}

extension FoodInfoExtension on List<FoodInfo> {
  ///Extension on List<FoodInfo> to verify the available box count.
  Future<bool> verifyAvailableBoxCount(
      BuildContext context, FoodBoxRepository foodBoxRepository) async {
    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      return false;
    }

    final requiredBoxes = <String, int>{};
    for (final foodInfo in this) {
      final foodBoxId = foodInfo.foodBoxId;
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
