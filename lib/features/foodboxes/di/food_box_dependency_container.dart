import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/foodboxes/data/repository/firebase_food_box_repository.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/food_box_service.dart';

/// DI setup for food boxes feature.
class FoodBoxDependencyContainer {
  const FoodBoxDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton<FoodBoxRepository>(
      FirebaseFoodBoxRepository(
        GetIt.I<FoodBoxService>(),
        GetIt.I<EntityPairService>(),
      ),
    );
  }
}
