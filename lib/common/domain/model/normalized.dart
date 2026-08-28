import 'package:zachranobed/common/domain/utils/string_utils.dart';

/// A value paired with a search-normalized key derived from it.
///
/// Computing the normalized key once lets callers filter or sort by it without
/// re-normalizing on every comparison.
class Normalized<T> {
  final String normalized;
  final T value;

  Normalized({required this.normalized, required this.value});

  /// Creates a [Normalized] from [value], normalizing the key returned by [keyOf].
  factory Normalized.of(T value, String Function(T value) keyOf) {
    return Normalized(normalized: keyOf(value).searchNormalized, value: value);
  }
}

/// A list of values each paired with a search-normalized key, so the list can
/// be filtered by a query without re-normalizing on every call.
class NormalizedList<T> {
  final List<T> items;
  final List<Normalized<T>> _normalized;

  NormalizedList(this.items, String Function(T value) keyOf)
    : _normalized = items.map((e) => Normalized.of(e, keyOf)).toList();

  /// Items whose normalized key contains the normalized [query].
  List<T> matches(String query) {
    final normalizedQuery = query.searchNormalized;
    return _normalized //
        .where((e) => e.normalized.contains(normalizedQuery))
        .map((e) => e.value)
        .toList();
  }
}
