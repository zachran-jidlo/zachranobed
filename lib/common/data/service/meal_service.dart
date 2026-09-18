import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/data/dto/meal_detail_dto.dart';
import 'package:zachranobed/common/domain/utils/future_utils.dart';
import 'package:zachranobed/common/domain/utils/iterable_utils.dart';

class MealService {
  final _collection = FirebaseFirestore.instance
      .collection('meals')
      .withConverter(
        fromFirestore: (snapshot, options) {
          final json = snapshot.data() ?? {};
          json['id'] = snapshot.id;
          return MealDetailDto.fromJson(json);
        },
        toFirestore: (value, options) {
          final json = value.toJson();
          json.remove('id');
          return json;
        },
      );

  /// Returns the meals with the given [ids], keyed by id. Anything that is not
  /// found is left out.
  ///
  /// Reads document by document on purpose. The rules allow `get` but not
  /// `list`, because the generated document id is the only thing that limits
  /// who can read a meal.
  Future<Map<String, MealDetailDto>> getDetails(List<String> ids) async {
    final snapshots = await Future.wait(ids.map((id) => _collection.doc(id).get()));
    final meals = snapshots.mapNotNull((e) => e.data());
    return {for (final meal in meals) meal.id: meal};
  }

  /// Adds the given [meals] to the collection. Returns a future with true
  /// when operation succeeds and false otherwise.
  Future<bool> addMeals(Iterable<MealDetailDto> meals) {
    return Future.wait(meals.map((e) => _collection.doc(e.id).set(e))).toSuccess();
  }
}
