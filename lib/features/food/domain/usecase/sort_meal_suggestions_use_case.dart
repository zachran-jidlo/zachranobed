import 'package:collection/collection.dart';
import 'package:zachranobed/common/domain/model/normalized.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';

class SortMealSuggestionsUseCase {
  /// Returns the [suggestions] sorted by name, case- and accent-insensitive.
  List<MealSuggestion> invoke(List<MealSuggestion> suggestions) {
    // Normalize each name once instead of recomputing both operands on every comparison
    return suggestions
        .map((s) => Normalized.of(s, (_) => s.name))
        .sorted((a, b) => a.normalized.compareTo(b.normalized))
        .map((e) => e.value)
        .toList();
  }
}
