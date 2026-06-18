import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';

class AddMealSuggestionUseCase {
  final MealSuggestionRepository _repository;

  AddMealSuggestionUseCase(this._repository);

  /// Creates a new meal suggestion for [entityId] with the given [name] and
  /// [allergens]. Returns the new id, or `null` on failure.
  Future<String?> invoke({
    required String entityId,
    required String name,
    required List<String> allergens,
  }) {
    return _repository.add(
      entityId: entityId,
      name: name,
      allergens: allergens,
    );
  }
}
