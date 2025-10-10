import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/menu/domain/model/contacts_summary.dart';

/// Repository to fetch contacts information.
abstract class ContactsRepository {
  /// Fetches available contacts for the [user].
  Future<ContactsSummary> getContacts({required UserData user});
}
