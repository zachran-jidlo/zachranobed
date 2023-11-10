import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/box.dart';

class BoxService {
  final _boxCollection =
      FirebaseFirestore.instance.collection('boxes').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return Box.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  /// Sets up a Firestore stream to listen for changes in the `boxes`
  /// collection, filtering the boxes based on the provided [establishmentId]
  /// that belongs to the currently signed in user. The user can be associated
  /// with the [Box] either as a `canteen` or a `charity`.
  ///
  /// Returns a [Stream] that emits a list of [Box] objects whenever
  /// there is a change in the Firestore collection that matches the specified
  /// criteria.
  Stream<List<Box>> loggedUserBoxesStream({required String establishmentId}) {
    final query = _boxCollection.where(Filter.or(
        Filter('charityId', isEqualTo: establishmentId),
        Filter('canteenId', isEqualTo: establishmentId)));

    return query.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  /// Verifies if the provided [numberOfBoxes] of a given [boxType]
  /// is available for the user specified by [establishmentId]. Optional
  /// [isCanteen] parameter determines if the user is from a canteen or a
  /// charity.
  ///
  /// Returns a [Future] that completes with a [bool] indicating whether the
  /// provided [numberOfBoxes] of the given [boxType] is available for the user.
  Future<bool> verifyAvailableBoxCount({
    required int numberOfBoxes,
    required String establishmentId,
    required String boxType,
    bool isCanteen = false,
  }) async {
    final query = _boxCollection
        .where(Filter.or(Filter('charityId', isEqualTo: establishmentId),
            Filter('canteenId', isEqualTo: establishmentId)))
        .where('boxType', isEqualTo: boxType);

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isEmpty) {
      return false;
    }

    final box = querySnapshot.docs.single.data();

    return isCanteen
        ? box.quantityAtCanteen >= numberOfBoxes
        : box.quantityAtCharity >= numberOfBoxes;
  }
}
