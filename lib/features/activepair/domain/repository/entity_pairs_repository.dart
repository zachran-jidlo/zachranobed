import 'package:zachranobed/features/activepair/domain/model/entity_pairs_summary.dart';
import 'package:zachranobed/models/user_data.dart';

/// Repository to manage entity pairs information.
abstract class EntityPairsRepository {
  /// Changes the active pair.
  Future<void> changeActivePair({
    required String donorId,
    required String recipientId,
  });

  /// Fetches available pairs summary information for the [user].
  Future<EntityPairsSummary> getEntityPairsSummary({
    required UserData user,
  });
}
