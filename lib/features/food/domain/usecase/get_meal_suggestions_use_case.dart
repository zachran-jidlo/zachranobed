import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';
import 'package:zachranobed/features/food/domain/usecase/sort_meal_suggestions_use_case.dart';

class GetMealSuggestionsUseCase {
  final MealSuggestionRepository _repository;
  final SortMealSuggestionsUseCase _sortMealSuggestions;

  GetMealSuggestionsUseCase(this._repository, this._sortMealSuggestions);

  /// Fetches the meal suggestions for the given [entityId], sorted by name.
  Future<List<MealSuggestion>> invoke({required String entityId}) async {
    final suggestions = await _repository.getAll(entityId: entityId);
    return _sortMealSuggestions.invoke(suggestions);
  }
}
