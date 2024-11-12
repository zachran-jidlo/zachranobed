import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';

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

/// Extensions on CollectionReference class.
extension CollectionReferenceUtils<T> on CollectionReference<T> {
  /// Fetches a list of [T] objects for the given document IDs.
  Future<List<T>> fetchMultipleDocs<V>(List<String> ids) async {
    // Firestore does not allow more than 30 "in" clauses, so we need to split
    // the list of IDs into chunks of 30.
    final List<T> results = [];
    for (var batch in ids.chunked(30)) {
      final snapshot = await where(FieldPath.documentId, whereIn: batch).get();
      results.addAll(snapshot.docs.mapNotNull((e) => e.data()).toList());
    }
    return results;
  }
}
