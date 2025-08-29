import 'package:zachranobed/features/appTerms/domain/repository/app_terms_repository.dart';
import 'package:zachranobed/services/entity_service.dart';

/// Implementation of the [AppTermsRepository] via Firebase services.
class FirebaseAppTermsRepository implements AppTermsRepository {
  final EntityService _entityService;

  /// Creates a new instance of [FirebaseAppTermsRepository].
  FirebaseAppTermsRepository(this._entityService);

  @override
  Future<void> updateAcceptedAppTermsVersion({
    required String entityId,
    required int appTermsVersion,
  }) {
    return _entityService.saveAppTermsVersion(entityId, appTermsVersion);
  }
}
