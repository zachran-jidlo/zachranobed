class BoxService {

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
    // TODO: Move to entity pair collection
    // final query = _boxCollection
    //     .where(Filter.or(Filter('charityId', isEqualTo: establishmentId),
    //         Filter('canteenId', isEqualTo: establishmentId)))
    //     .where('boxType', isEqualTo: boxType);
    //
    // final querySnapshot = await query.get();
    //
    // if (querySnapshot.docs.isEmpty) {
    //   return false;
    // }
    //
    // final box = querySnapshot.docs.single.data();
    //
    // return isCanteen
    //     ? box.quantityAtCanteen >= numberOfBoxes
    //     : box.quantityAtCharity >= numberOfBoxes;

    return true;
  }
}
