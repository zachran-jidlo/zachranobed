import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/features/menu/domain/model/contact.dart';
import 'package:zachranobed/features/menu/domain/model/entity_contacts.dart';

/*
 * Command to rebuild the contacts_summary.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'contacts_summary.freezed.dart';

@Freezed()
class ContactsSummary with _$ContactsSummary {
  const factory ContactsSummary({
    required List<EntityContacts> targets,
    required List<Contact> deliveryContacts,
    required List<Contact> organisationContacts,
  }) = $ContactsSummary;
}
