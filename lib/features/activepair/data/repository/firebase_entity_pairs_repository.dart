import 'package:collection/collection.dart';
import 'package:zachranobed/common/data/mapper/entity_pair_mapper.dart';
import 'package:zachranobed/common/data/prefs/app_preferences.dart';
import 'package:zachranobed/common/data/prefs/entity_pair_struct.dart';
import 'package:zachranobed/common/data/service/entity_pairs_service.dart';
import 'package:zachranobed/common/data/service/entity_service.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/activepair/domain/model/entity_pairs_summary.dart';
import 'package:zachranobed/features/activepair/domain/repository/entity_pairs_repository.dart';

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

    final allPairs = await pairs.toDomain(
      userEntityId: user.entityId,
      entities: _entityService.fetchEntities,
    );

    // Pairs turned off by an admin must not be offered to the user
    final enabledPairs = allPairs.where((pair) => pair.enabled).toList();

    final activePair = enabledPairs.firstWhereOrNull(
          (pair) => pair.donorId == user.activePair.donorId && pair.recipientId == user.activePair.recipientId,
        ) ??
        user.activePair;

    return EntityPairsSummary(
      active: activePair,
      otherPairs: enabledPairs
          .whereNot(
            (pair) => pair.donorId == activePair.donorId && pair.recipientId == activePair.recipientId,
          )
          .toList(),
    );
  }
}
