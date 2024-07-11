import 'package:collection/collection.dart';
import 'package:zachranobed/common/utils/generic_utils.dart';
import 'package:zachranobed/features/menu/data/mapper/contacts_mapper.dart';
import 'package:zachranobed/features/menu/domain/model/contact.dart';
import 'package:zachranobed/features/menu/domain/model/contacts_summary.dart';
import 'package:zachranobed/features/menu/domain/model/entity_contacts.dart';
import 'package:zachranobed/features/menu/domain/repository/contacts_repository.dart';
import 'package:zachranobed/services/configuration_service.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/entity_service.dart';

/// Implementation of the [ContactsRepository] via Firebase services.
class FirebaseContactsRepository implements ContactsRepository {
  final EntityService _entityService;
  final EntityPairService _entityPairService;
  final ConfigurationService _configurationService;

  FirebaseContactsRepository(
    this._entityService,
    this._entityPairService,
    this._configurationService,
  );

  @override
  Future<ContactsSummary> getContacts({required String entityId}) async {
    final targetEntityIds = await getTargetEntityIds(entityId);
    return Future.wait(
      [
        getEntityContacts(targetEntityIds.toList()),
        getDeliveryContacts(),
        getOrganisationContacts(),
      ],
    ).then((values) {
      return ContactsSummary(
        targets: values[0].cast(),
        deliveryContacts: values[1].cast(),
        organisationContacts: values[2].cast(),
      );
    });
  }

  /// Retrieves a list of entity IDs that are paired with the given [entityId].
  Future<Iterable<String>> getTargetEntityIds(String entityId) async {
    final pairs = await _entityPairService.observePairs(entityId).first;
    return pairs.map((pair) {
      return entityId == pair.recipientId ? pair.donorId : pair.recipientId;
    });
  }

  /// Retrieves a list of [EntityContacts] of given entity IDs.
  /// The final list is sorted by establishment name.
  Future<List<EntityContacts>> getEntityContacts(
    List<String> entityIds,
  ) async {
    final entities = await _entityService.fetchEntities(entityIds);
    return entities.map((e) {
      final mainContact = Contact(
        name: e.responsiblePerson,
        phoneNumber: e.phone?.takeIf((e) => e.isNotEmpty),
      );
      final contacts = (e.additionalContacts ?? []).map((e) => e.toDomain());

      return EntityContacts(
        name: e.establishmentName,
        contacts: [mainContact, ...contacts],
      );
    }).sortedBy((e) => e.name);
  }

  /// Retrieves a list of contacts of carriers.
  Future<List<Contact>> getDeliveryContacts() {
    // TODO (ZOB-223) Replace mocked values in next PR part
    return Future.value(
      [
        const Contact(
          name: "DODO - dispečink",
          phoneNumber: "+420 XXX XXX XXX",
        ),
      ],
    );
  }

  /// Retrieves a list of contacts of ZOB organisation.
  Future<List<Contact>> getOrganisationContacts() {
    return _configurationService.fetchContacts().then((contacts) {
      if (contacts == null) {
        return [];
      }
      return contacts.organisationContacts.map((e) => e.toDomain()).toList();
    });
  }
}
