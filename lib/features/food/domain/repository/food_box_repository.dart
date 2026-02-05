import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/model/food_box_type.dart';

/// Repository to manage food boxes information
abstract class FoodBoxRepository {

  /// Returns a disposable box ID.
  String getDisposableBoxId();

  /// Fetches a list of available food box types.
  /// Use [includeDisposable] flag to control whether disposable box type
  /// should be returned.
  Future<Iterable<FoodBoxType>> getTypes({bool includeDisposable = false});

  /// Return a stream with a list of food box statistics for the [user].
  Stream<Iterable<FoodBoxStatistics>> observeStatistics(UserData user);

  /// Creates a box delivery from the given [user] to its active pair.
  /// The [boxesQuantity] maps food box type IDs to their counts.
  Future<bool> createBoxDelivery({
    required UserData user,
    required Map<String, int> boxesQuantity,
  });

  /// Delays a food boxes checkup for the given [user].
  Future<bool> delayFoodBoxesCheckup({
    required UserData user,
  });

  /// Reports a mismatch in a food boxes checkup for the given [user].
  Future<bool> reportFoodBoxesMismatch({
    required UserData user,
  });

  /// Verifies a food boxes checkup for the given [user].
  Future<bool> verifyFoodBoxesCheckup({
    required UserData user,
  });
}
