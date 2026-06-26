import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';

class AddMealSuggestionUseCase {
  final MealSuggestionRepository _repository;

  AddMealSuggestionUseCase(this._repository);

  /// Adds a meal suggestion for [entityId]. Returns `true` on success.
  ///
  /// Caller is responsible for duplicate checking (see [CheckMealSuggestionDuplicateUseCase]).
  Future<bool> invoke({
    required String entityId,
    required String name,
    required List<String> allergens,
  }) async {
    final id = await _repository.add(entityId: entityId, name: name, allergens: allergens);
    return id != null;
  }
}
