/// A single box-type entry submitted by the user when reporting a mismatch
/// during a food boxes checkup.
///
/// [systemCount] is the count the app believed to be correct at the moment of
/// the report, [realCount] is the count the user physically has.
class FoodBoxesCheckupReportedCount {
  /// Identifier of the food box type.
  final String foodBoxId;

  /// The count the user actually has.
  final int realCount;

  /// The count recorded in the system at the time of the report.
  final int systemCount;

  const FoodBoxesCheckupReportedCount({
    required this.foodBoxId,
    required this.realCount,
    required this.systemCount,
  });
}
