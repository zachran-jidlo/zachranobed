import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/domain/utils/future_utils.dart';
import 'package:zachranobed/features/food/data/dto/meal_suggestion_dto.dart';

/// A service class for managing meal suggestions related to a specific entity.
///
/// Meal suggestions are stored in the `mealSuggestions` subcollection under
/// each entity document and back the autocomplete on the meal registration
/// screen.
class MealSuggestionService {
  CollectionReference<MealSuggestionDto> getCollection(String entityId) {
    return FirebaseFirestore.instance
        .collection('entities')
        .doc(entityId)
        .collection('mealSuggestions')
        .withConverter(
          fromFirestore: (snapshot, _) {
            final json = snapshot.data() ?? {};
            json['id'] = snapshot.id;
            return MealSuggestionDto.fromJson(json);
          },
          toFirestore: (value, options) {
            final json = value.toJson();
            json.remove('id');
            return json;
          },
        );
  }

  /// Observes the list of [MealSuggestionDto] for the given [entityId].
  Stream<List<MealSuggestionDto>> observe(String entityId) {
    return getCollection(entityId) //
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()).toList());
  }

  /// Fetches the list of [MealSuggestionDto] for the given [entityId] once.
  Future<List<MealSuggestionDto>> getAll(String entityId) async {
    final snapshot = await getCollection(entityId).get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  /// Creates or updates the given [dto] under [entityId]. Returns a future with
  /// true when the operation succeeds and false otherwise.
  Future<bool> save(String entityId, MealSuggestionDto dto) {
    return getCollection(entityId).doc(dto.id).set(dto).toSuccess();
  }

  /// Deletes the suggestion with the given [id] under [entityId]. Returns a
  /// future with true when the operation succeeds and false otherwise.
  Future<bool> delete(String entityId, String id) {
    return getCollection(entityId).doc(id).delete().toSuccess();
  }
}
