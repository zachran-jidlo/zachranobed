import 'package:zachranobed/features/menu/domain/model/contacts_summary.dart';
import 'package:zachranobed/models/user_data.dart';

/// Repository to fetch contacts information.
abstract class ContactsRepository {
  /// Fetches available contacts for the [user].
  Future<ContactsSummary> getContacts({required UserData user});
}
