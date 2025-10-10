import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/menu/domain/model/contacts_summary.dart';
import 'package:zachranobed/features/menu/domain/repository/contacts_repository.dart';

/// A use case for retrieving contact information.
class GetContactsUseCase {
  final ContactsRepository _repository;

  GetContactsUseCase(this._repository);

  /// Fetches available contacts for the [user].
  Future<ContactsSummary> invoke(UserData user) {
    return _repository.getContacts(user: user);
  }
}
