/// Known carrier identifiers with a dedicated meaning.
enum CarrierType {
  /// The recipient collects the donation themselves, without a delivery service.
  personal('personal'),

  /// Delivery is turned off for the pair.
  disabled('disabled');

  /// The value stored in the pair's `carrierId` field.
  final String id;

  const CarrierType(this.id);
}
