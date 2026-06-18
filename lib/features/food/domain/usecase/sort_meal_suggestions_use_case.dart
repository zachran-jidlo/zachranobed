import 'package:collection/collection.dart';
import 'package:zachranobed/common/domain/utils/string_utils.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';

class SortMealSuggestionsUseCase {
  /// Returns the [suggestions] sorted by name, case- and accent-insensitive.
  List<MealSuggestion> invoke(List<MealSuggestion> suggestions) {
    return suggestions.sorted((a, b) => a.name.searchNormalized.compareTo(b.name.searchNormalized));
  }
}
