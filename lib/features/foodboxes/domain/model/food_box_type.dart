import 'package:collection/collection.dart';

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
  /// Returns the [FoodBoxType] with the given [id] or `null` if no such type exists.
  FoodBoxType? getById(String id) {
    return firstWhereOrNull((type) => type.id == id);
  }
}
