import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';

class DeleteMealSuggestionUseCase {
  final MealSuggestionRepository _repository;

  DeleteMealSuggestionUseCase(this._repository);

  /// Deletes the suggestion with the given [id] for [entityId]. Returns `true`
  /// on success, `false` otherwise.
  Future<bool> invoke({
    required String entityId,
    required String id,
  }) {
    return _repository.delete(
      entityId: entityId,
      id: id,
    );
  }
}
