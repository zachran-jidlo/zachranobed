import 'package:cloud_firestore/cloud_firestore.dart';

/// Extensions on Query class.
extension QueryUtils<T> on Query<T> {
  /// Creates and returns a new [Query] with additional filter on specified
  /// [field] by given [time].
  Query<T> whereTime<V>(Object field, DateTime time) {
    final from = Timestamp.fromDate(time);
    final to = Timestamp.fromDate(time.add(const Duration(seconds: 1)));
    return where(field, isGreaterThanOrEqualTo: from)
        .where(field, isLessThanOrEqualTo: to);
  }
}
