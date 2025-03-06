import 'package:collection/collection.dart';
import 'package:zachranobed/enums/food_category.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_date_time.dart';
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';
import 'package:zachranobed/models/dto/delivery_dto.dart';
import 'package:zachranobed/models/dto/meal_detail_dto.dart';
import 'package:zachranobed/models/dto/meal_dto.dart';

/// DTO to domain mapper for [OfferedFood].
extension OfferedFoodMapper on MealDetailDto {
  /// Maps DTOs to domain representation.
  OfferedFood toDomain(DeliveryDto delivery, MealDto meal, String? boxType) {
    // The [preparedAt] field is set only for "cooled" meals, otherwise is set
    // to null. This is because the [preparedAt] field is only relevant for
    // cooled food categories.
    FoodDateTime? preparedAt;
    if (foodCategoryType == FoodCategoryType.cooled.name) {
      preparedAt = _getFoodDateTime(meal.preparedAt);
    }

    return OfferedFood(
      id: id,
      date: delivery.deliveryDate,
      dishName: name,
      foodCategory: foodCategory,
      foodCategoryType: _getFoodCategoryType(foodCategoryType),
      foodTemperature: meal.foodTemperature,
      allergens: allergens,
      numberOfServings: meal.count,
      boxType: boxType,
      preparedAt: preparedAt,
      consumeBy: _getFoodDateTime(meal.consumeBy),
      donorId: delivery.donorId,
      recipientId: delivery.recipientId,
      numberOfBoxes: meal.foodBoxCount,
      numberOfPackages: meal.packagesCount,
    );
  }

  FoodDateTime _getFoodDateTime(DateTime? date) {
    if (date != null) {
      return FoodDateTimeSpecified(date: date);
    } else {
      return FoodDateTimeOnPackaging();
    }
  }

  FoodCategoryType? _getFoodCategoryType(String? foodCategoryTypeName) =>
      FoodCategoryType.values.firstWhereOrNull((element) => element.name == foodCategoryTypeName);
}
