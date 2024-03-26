import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';
import 'package:zachranobed/models/dto/delivery_dto.dart';
import 'package:zachranobed/models/dto/meal_detail_dto.dart';
import 'package:zachranobed/models/dto/meal_dto.dart';

/// DTO to domain mapper for [OfferedFood].
extension OfferedFoodMapper on MealDetailDto {
  /// Maps DTOs to domain representation.
  OfferedFood toDomain(DeliveryDto delivery, MealDto meal, String boxType) {
    return OfferedFood(
      id: id,
      date: delivery.deliveryDate,
      dishName: name,
      foodCategory: foodCategory,
      allergens: allergens,
      numberOfServings: meal.count,
      boxType: boxType,
      consumeBy: meal.consumeBy,
      donorId: delivery.donorId,
      recipientId: delivery.recipientId,
      numberOfBoxes: meal.foodBoxCount,
    );
  }
}
