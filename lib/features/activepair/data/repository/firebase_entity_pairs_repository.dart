import 'package:collection/collection.dart';
import 'package:zachranobed/common/prefs/app_preferences.dart';
import 'package:zachranobed/common/prefs/entity_pair_struct.dart';
import 'package:zachranobed/features/activepair/domain/model/entity_pairs_summary.dart';
import 'package:zachranobed/features/activepair/domain/repository/entity_pairs_repository.dart';
import 'package:zachranobed/models/mapper/entity_pair_mapper.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/entity_service.dart';

/// Implementation of the [EntityPairsRepository] via Firebase services.
class FirebaseEntityPairsRepository implements EntityPairsRepository {
  final EntityService _entityService;
  final EntityPairService _entityPairService;
  final AppPreferences _appPreferences;

  FirebaseEntityPairsRepository(
    this._entityService,
    this._entityPairService,
    this._appPreferences,
  );

  @override
  Future<void> changeActivePair({
    required String donorId,
    required String recipientId,
  }) async {
    _appPreferences.setActivePair(
      EntityPairStruct(
        donorId: donorId,
        recipientId: recipientId,
      ),
    );
  }

  @override
  Future<EntityPairsSummary> getEntityPairsSummary({
    required UserData user,
  }) async {
    final pairs = await _entityPairService.getByUser(user);
    if (pairs == null) {
      throw Exception('Unable to retrieve entity pairs summary');
    }

    final entityPairs = await pairs.toDomain(
      userEntityId: user.entityId,
      entities: _entityService.fetchEntities,
    );

    final activePair = entityPairs.firstWhere(
      (pair) =>
          pair.donorId == user.activePair.donorId &&
          pair.recipientId == user.activePair.recipientId,
    );

    return EntityPairsSummary(
      active: activePair,
      otherPairs: entityPairs
          .whereNot(
            (pair) =>
                pair.donorId == activePair.donorId &&
                pair.recipientId == activePair.recipientId,
          )
          .toList(),
    );
  }
}
