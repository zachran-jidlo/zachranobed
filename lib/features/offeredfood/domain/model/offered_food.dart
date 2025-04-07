import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/enums/food_category.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_date_time.dart';

/*
 * Command to rebuild the offered_food.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'offered_food.freezed.dart';

@Freezed()
class OfferedFood with _$OfferedFood {
  const factory OfferedFood({
    required String id,
    required DateTime date,
    required String dishName,
    required String foodCategory,
    required FoodCategoryType? foodCategoryType,
    required int? foodTemperature,
    required List<String> allergens,
    required int? numberOfServings,
    required int? numberOfPackages,
    required FoodDateTime? preparedAt,
    required FoodDateTime consumeBy,
    required String donorId,
    required String recipientId,
  }) = _OfferedFood;
}
