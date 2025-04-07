import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/offeredfood/data/repository/firebase_offered_food_repository.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/food_box_service.dart';
import 'package:zachranobed/services/meal_service.dart';

/// DI setup for offered food feature.
class OfferedFoodDependencyContainer {
  const OfferedFoodDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton<OfferedFoodRepository>(
      FirebaseOfferedFoodRepository(
        GetIt.I<DeliveryService>(),
        GetIt.I<MealService>(),
        GetIt.I<EntityPairService>(),
      ),
    );
  }
}
