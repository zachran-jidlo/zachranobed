import 'package:zachranobed/features/activepair/domain/model/entity_pairs_summary.dart';
import 'package:zachranobed/features/activepair/domain/repository/entity_pairs_repository.dart';
import 'package:zachranobed/models/user_data.dart';

/// A use case for retrieving entity pairs summary information.
class GetEntityPairsSummaryUseCase {
  final EntityPairsRepository _repository;

  GetEntityPairsSummaryUseCase(this._repository);

  /// Fetches available pairs summary information for the [user].
  Future<EntityPairsSummary> invoke(UserData user) {
    return _repository.getEntityPairsSummary(user: user);
  }
}
