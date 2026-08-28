import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';
import 'package:zachranobed/features/food/domain/usecase/sort_meal_suggestions_use_case.dart';

class ObserveMealSuggestionsUseCase {
  final MealSuggestionRepository _repository;
  final SortMealSuggestionsUseCase _sortMealSuggestions;

  ObserveMealSuggestionsUseCase(this._repository, this._sortMealSuggestions);

  /// Observes the meal suggestions for the given [entityId], sorted by name.
  Stream<List<MealSuggestion>> invoke({required String entityId}) {
    return _repository.observe(entityId: entityId).map((suggestions) => _sortMealSuggestions.invoke(suggestions));
  }
}
