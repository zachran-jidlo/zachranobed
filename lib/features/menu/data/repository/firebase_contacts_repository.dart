import 'package:collection/collection.dart';
import 'package:zachranobed/common/utils/generic_utils.dart';
import 'package:zachranobed/features/menu/data/mapper/contacts_mapper.dart';
import 'package:zachranobed/features/menu/domain/model/contact.dart';
import 'package:zachranobed/features/menu/domain/model/contacts_summary.dart';
import 'package:zachranobed/features/menu/domain/model/entity_contacts.dart';
import 'package:zachranobed/features/menu/domain/repository/contacts_repository.dart';
import 'package:zachranobed/models/dto/entity_pair_dto.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/carrier_service.dart';
import 'package:zachranobed/services/configuration_service.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/entity_service.dart';

/// Implementation of the [ContactsRepository] via Firebase services.
class FirebaseContactsRepository implements ContactsRepository {
  final EntityService _entityService;
  final EntityPairService _entityPairService;
  final ConfigurationService _configurationService;
  final CarrierService _carrierService;

  FirebaseContactsRepository(
    this._entityService,
    this._entityPairService,
    this._configurationService,
    this._carrierService,
  );

  @override
  Future<ContactsSummary> getContacts({required UserData user}) async {
    final pairs = await _entityPairService.getByUser(user);
    if (pairs == null) {
      throw Exception('Unable to retrieve entity pairs summary');
    }
    return Future.wait(
      [
        getEntityContacts(getTargetEntityIds(user.entityId, pairs)),
        getDeliveryContacts(pairs),
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
  List<String> getTargetEntityIds(
    String entityId,
    List<EntityPairDto> pairs,
  ) {
    return pairs
        .map((e) => entityId == e.recipientId ? e.donorId : e.recipientId)
        .toList();
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
        position: e.responsiblePersonPosition?.takeIf((e) => e.isNotEmpty),
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
  Future<List<Contact>> getDeliveryContacts(
    List<EntityPairDto> pairs,
  ) {
    // Get a set of carrier IDs to exclude duplicates
    final carrierIds = pairs.map((e) => e.carrierId).toSet().toList();
    return _carrierService.fetchCarriers(carrierIds).then((carriers) {
      return carriers
          .map((e) => e.contacts ?? [])
          .flattened
          .map((e) => e.toDomain())
          .toList();
    });
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
