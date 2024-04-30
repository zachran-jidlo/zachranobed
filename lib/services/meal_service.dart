import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/utils/future_utils.dart';
import 'package:zachranobed/models/dto/meal_detail_dto.dart';

class MealService {
  final _collection =
      FirebaseFirestore.instance.collection('meals').withConverter(
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

  /// Queries the Firestore collection for meals with given IDs and returns a
  /// map with data.
  Future<Map<String, MealDetailDto>> getDetails(List<String> ids) async {
    final snapshot =
        await _collection.where(FieldPath.documentId, whereIn: ids).get();

    return {for (final v in snapshot.docs) v.id: v.data()};
  }

  /// Adds the given [meals] to the collection. Returns a future with true
  /// when operation succeeds and false otherwise.
  Future<bool> addMeals(Iterable<MealDetailDto> meals) {
    return Future.wait(meals.map((e) => _collection.doc(e.id).set(e)))
        .toSuccess();
  }
}
