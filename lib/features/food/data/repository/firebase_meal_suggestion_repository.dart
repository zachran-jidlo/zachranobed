import 'package:uuid/uuid.dart';
import 'package:zachranobed/features/food/data/dto/meal_suggestion_dto.dart';
import 'package:zachranobed/features/food/data/mapper/meal_suggestion_mapper.dart';
import 'package:zachranobed/features/food/data/service/meal_suggestion_service.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';

class FirebaseMealSuggestionRepository implements MealSuggestionRepository {
  final MealSuggestionService _service;

  FirebaseMealSuggestionRepository(this._service);

  @override
  Stream<List<MealSuggestion>> observe({required String entityId}) {
    return _service.observe(entityId).map((dtos) => dtos.toDomain());
  }

  @override
  Future<List<MealSuggestion>> getAll({required String entityId}) async {
    final dtos = await _service.getAll(entityId);
    return dtos.toDomain();
  }

  @override
  Future<String?> add({
    required String entityId,
    required String name,
    required List<String> allergens,
  }) async {
    const uuid = Uuid();
    final dto = MealSuggestionDto(
      id: uuid.v4(),
      name: name,
      allergens: allergens,
    );

    final success = await _service.save(entityId, dto);
    return success ? dto.id : null;
  }

  @override
  Future<bool> update({
    required String entityId,
    required MealSuggestion suggestion,
  }) {
    return _service.save(entityId, suggestion.toDto());
  }

  @override
  Future<bool> delete({
    required String entityId,
    required String id,
  }) {
    return _service.delete(entityId, id);
  }
}
