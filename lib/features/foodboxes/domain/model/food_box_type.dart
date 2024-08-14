class FoodBoxType {
  final String id;
  final String name;
  final String type;

  const FoodBoxType({
    required this.id,
    required this.name,
    required this.type,
  });
}

extension FoodBoxTypeListExtensions on List<FoodBoxType> {
  /// Returns the first element that satisfies the given predicate [test].
  FoodBoxType? getById(String id) {
    try {
      return firstWhere((type) => type.id == id);
    } catch (e) {
      return null;
    }
  }
}
