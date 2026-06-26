import 'package:collection/collection.dart';
import 'package:zachranobed/common/domain/utils/string_utils.dart';

class GetMealSuggestionKeyUseCase {
  /// Builds the key used to detect duplicate meal suggestions.
  ///
  /// Two meals are considered the same only when they share a normalized name
  /// (case- and accent-insensitive) and the same allergen set (order-independent).
  String invoke({
    required String name,
    required List<String> allergens,
  }) {
    return '${name.searchNormalized}|${allergens.sorted().join(',')}';
  }
}
