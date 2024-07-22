import 'package:zachranobed/features/menu/domain/model/contacts_summary.dart';
import 'package:zachranobed/features/menu/domain/repository/contacts_repository.dart';

/// A use case for retrieving contact information.
class GetContactsUseCase {
  final ContactsRepository _repository;

  GetContactsUseCase(this._repository);

  /// Fetches available contacts for the user with given [entityId].
  Future<ContactsSummary> invoke(String entityId) {
    return _repository.getContacts(entityId: entityId);
  }
}
