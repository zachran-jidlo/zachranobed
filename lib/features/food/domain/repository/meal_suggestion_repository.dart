import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';

/// Repository for managing meal suggestions stored per entity.
abstract class MealSuggestionRepository {
  /// Observes the meal suggestions for the given [entityId].
  Stream<List<MealSuggestion>> observe({required String entityId});

  /// Fetches the meal suggestions for the given [entityId] once.
  Future<List<MealSuggestion>> getAll({required String entityId});

  /// Creates a new suggestion for [entityId] with the given [name] and
  /// [allergens]. Generates a new id and returns it, or `null` on failure.
  Future<String?> add({
    required String entityId,
    required String name,
    required List<String> allergens,
  });

  /// Updates the given [suggestion] for [entityId]. Returns `true` on success,
  /// `false` otherwise.
  Future<bool> update({
    required String entityId,
    required MealSuggestion suggestion,
  });

  /// Deletes the suggestion with the given [id] for [entityId]. Returns `true`
  /// on success, `false` otherwise.
  Future<bool> delete({
    required String entityId,
    required String id,
  });
}
