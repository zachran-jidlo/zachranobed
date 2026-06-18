import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';

class ObserveMealSuggestionsUseCase {
  final MealSuggestionRepository _repository;

  ObserveMealSuggestionsUseCase(this._repository);

  /// Observes the meal suggestions for the given [entityId].
  Stream<List<MealSuggestion>> invoke({required String entityId}) {
    return _repository.observe(entityId: entityId);
  }
}
