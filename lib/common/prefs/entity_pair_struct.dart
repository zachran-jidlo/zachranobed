/// Represents an entity pair between donor and recipient (canteen and charity).
class EntityPairStruct {
  /// The entity ID of the donor entity.
  final String donorId;

  /// The entity ID of the recipient entity.
  final String recipientId;

  /// Creates a new [EntityPairStruct] instance.
  EntityPairStruct({
    required this.donorId,
    required this.recipientId,
  });
}
