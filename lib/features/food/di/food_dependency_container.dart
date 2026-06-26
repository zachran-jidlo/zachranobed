import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/data/service/delivery_service.dart';
import 'package:zachranobed/common/data/service/entity_pairs_service.dart';
import 'package:zachranobed/common/data/service/food_box_service.dart';
import 'package:zachranobed/common/data/service/meal_service.dart';
import 'package:zachranobed/features/food/data/repository/firebase_food_box_repository.dart';
import 'package:zachranobed/features/food/data/repository/firebase_meal_suggestion_repository.dart';
import 'package:zachranobed/features/food/data/repository/firebase_offered_food_repository.dart';
import 'package:zachranobed/features/food/data/service/meal_suggestion_service.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';
import 'package:zachranobed/features/food/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/features/food/domain/usecase/add_meal_suggestion_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/create_box_delivery_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/create_food_offer_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/delay_food_boxes_checkup_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/delete_meal_suggestion_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/get_history_paginated_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_delivery_meals_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_food_box_statistics_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_meal_suggestions_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestions_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/check_meal_suggestion_duplicate_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestion_key_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/report_food_boxes_mismatch_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/save_meal_suggestions_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/sort_meal_suggestions_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/update_meal_suggestion_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/verify_available_box_count_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/verify_food_boxes_checkup_use_case.dart';

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
      ),
    );

    GetIt.I.registerSingleton(MealSuggestionService());

    GetIt.I.registerSingleton<MealSuggestionRepository>(
      FirebaseMealSuggestionRepository(
        GetIt.I<MealSuggestionService>(),
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

    GetIt.I.registerFactory<VerifyFoodBoxesCheckupUseCase>(
      () => VerifyFoodBoxesCheckupUseCase(
        GetIt.I<FoodBoxRepository>(),
      ),
    );

    GetIt.I.registerFactory<ReportFoodBoxesMismatchUseCase>(
      () => ReportFoodBoxesMismatchUseCase(
        GetIt.I<FoodBoxRepository>(),
      ),
    );

    GetIt.I.registerFactory<DelayFoodBoxesCheckupUseCase>(
      () => DelayFoodBoxesCheckupUseCase(
        GetIt.I<FoodBoxRepository>(),
      ),
    );

    GetIt.I.registerFactory<VerifyAvailableBoxCountUseCase>(
      () => VerifyAvailableBoxCountUseCase(
        GetIt.I<FoodBoxRepository>(),
      ),
    );

    GetIt.I.registerFactory<CreateBoxDeliveryUseCase>(
      () => CreateBoxDeliveryUseCase(
        GetIt.I<FoodBoxRepository>(),
      ),
    );

    GetIt.I.registerFactory<CreateFoodOfferUseCase>(
      () => CreateFoodOfferUseCase(
        GetIt.I<OfferedFoodRepository>(),
      ),
    );

    GetIt.I.registerFactory<SortMealSuggestionsUseCase>(
      () => SortMealSuggestionsUseCase(),
    );

    GetIt.I.registerFactory<GetMealSuggestionKeyUseCase>(
      () => GetMealSuggestionKeyUseCase(),
    );

    GetIt.I.registerFactory<ObserveMealSuggestionsUseCase>(
      () => ObserveMealSuggestionsUseCase(
        GetIt.I<MealSuggestionRepository>(),
        GetIt.I<SortMealSuggestionsUseCase>(),
      ),
    );

    GetIt.I.registerFactory<GetMealSuggestionsUseCase>(
      () => GetMealSuggestionsUseCase(
        GetIt.I<MealSuggestionRepository>(),
        GetIt.I<SortMealSuggestionsUseCase>(),
      ),
    );

    GetIt.I.registerFactory<SaveMealSuggestionsUseCase>(
      () => SaveMealSuggestionsUseCase(
        GetIt.I<MealSuggestionRepository>(),
        GetIt.I<GetMealSuggestionKeyUseCase>(),
      ),
    );

    GetIt.I.registerFactory<AddMealSuggestionUseCase>(
      () => AddMealSuggestionUseCase(
        GetIt.I<MealSuggestionRepository>(),
      ),
    );

    GetIt.I.registerFactory<UpdateMealSuggestionUseCase>(
      () => UpdateMealSuggestionUseCase(
        GetIt.I<MealSuggestionRepository>(),
      ),
    );

    GetIt.I.registerFactory<CheckMealSuggestionDuplicateUseCase>(
      () => CheckMealSuggestionDuplicateUseCase(
        GetIt.I<GetMealSuggestionKeyUseCase>(),
      ),
    );

    GetIt.I.registerFactory<DeleteMealSuggestionUseCase>(
      () => DeleteMealSuggestionUseCase(
        GetIt.I<MealSuggestionRepository>(),
      ),
    );
  }
}
