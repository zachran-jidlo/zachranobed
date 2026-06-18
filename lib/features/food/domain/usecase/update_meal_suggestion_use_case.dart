import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';

class UpdateMealSuggestionUseCase {
  final MealSuggestionRepository _repository;

  UpdateMealSuggestionUseCase(this._repository);

  /// Updates the given [suggestion] for [entityId]. Returns `true` on success,
  /// `false` otherwise.
  Future<bool> invoke({
    required String entityId,
    required MealSuggestion suggestion,
  }) {
    return _repository.update(
      entityId: entityId,
      suggestion: suggestion,
    );
  }
}
