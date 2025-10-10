/// Represents a type of food box.
class FoodBoxType {
  /// The unique identifier for this box type.
  final String id;

  /// The name of this box type to show in UI.
  final String name;

  /// Creates a new [FoodBoxType] instance.
  const FoodBoxType({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodBoxType &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
