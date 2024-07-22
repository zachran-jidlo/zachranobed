import 'package:zachranobed/features/menu/domain/model/contacts_summary.dart';

/// Repository to fetch contacts information.
abstract class ContactsRepository {
  /// Fetches available contacts for the user with given [entityId].
  Future<ContactsSummary> getContacts({required String entityId});
}
