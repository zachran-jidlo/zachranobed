import 'package:zachranobed/features/activepair/domain/repository/entity_pairs_repository.dart';

/// A use case for changing the active pair.
class ChangeActivePairUseCase {
  final EntityPairsRepository _repository;

  ChangeActivePairUseCase(this._repository);

  /// Changes the active pair.
  Future<void> invoke(String donorId, String recipientId) {
    return _repository.changeActivePair(
      donorId: donorId,
      recipientId: recipientId,
    );
  }
}
