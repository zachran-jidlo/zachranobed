import 'package:zachranobed/features/food/domain/model/food_box_type.dart';

class FoodBoxStatistics {
  final FoodBoxType type;
  final int totalQuantity;
  final int quantityAtCharity;
  final int quantityAtCanteen;

  const FoodBoxStatistics({
    required this.type,
    required this.totalQuantity,
    required this.quantityAtCharity,
    required this.quantityAtCanteen,
  });
}
