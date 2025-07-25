import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/features/menu/domain/model/contact.dart';

/*
 * Command to rebuild the entity_contacts.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'entity_contacts.freezed.dart';

@freezed
abstract class EntityContacts with _$EntityContacts {
  const factory EntityContacts({
    required String name,
    required bool active,
    required List<Contact> contacts,
  }) = $EntityContacts;
}
