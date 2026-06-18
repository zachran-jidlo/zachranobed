import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';

class GetMealSuggestionsUseCase {
  final MealSuggestionRepository _repository;

  GetMealSuggestionsUseCase(this._repository);

  /// Fetches the meal suggestions for the given [entityId].
  Future<List<MealSuggestion>> invoke({required String entityId}) {
    return _repository.getAll(entityId: entityId);
  }
}
