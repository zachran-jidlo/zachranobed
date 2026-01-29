import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/data/service/delivery_service.dart';
import 'package:zachranobed/common/data/service/entity_pairs_service.dart';
import 'package:zachranobed/common/data/service/food_box_service.dart';
import 'package:zachranobed/common/data/service/meal_service.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';
import 'package:zachranobed/features/food/data/repository/firebase_food_box_repository.dart';
import 'package:zachranobed/features/food/data/repository/firebase_offered_food_repository.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/food/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/features/food/domain/usecase/get_history_paginated_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_delivery_meals_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_food_box_statistics_use_case.dart';

/// DI setup for food feature.
class FoodDependencyContainer {
  const FoodDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton<FoodBoxRepository>(
      FirebaseFoodBoxRepository(
        GetIt.I<FoodBoxService>(),
        GetIt.I<EntityPairService>(),
        GetIt.I<DeliveryService>(),
      ),
    );

    GetIt.I.registerSingleton<OfferedFoodRepository>(
      FirebaseOfferedFoodRepository(
        GetIt.I<DeliveryService>(),
        GetIt.I<MealService>(),
        GetIt.I<EntityPairService>(),
        GetIt.I<DeliveryRepository>(),
      ),
    );

    GetIt.I.registerFactory<GetHistoryPaginatedUseCase>(
      () => GetHistoryPaginatedUseCase(
        GetIt.I<OfferedFoodRepository>(),
      ),
    );

    GetIt.I.registerFactory<ObserveFoodBoxStatisticsUseCase>(
      () => ObserveFoodBoxStatisticsUseCase(
        GetIt.I<FoodBoxRepository>(),
      ),
    );

    GetIt.I.registerFactory<ObserveDeliveryMealsUseCase>(
      () => ObserveDeliveryMealsUseCase(
        GetIt.I<OfferedFoodRepository>(),
      ),
    );
  }
}
