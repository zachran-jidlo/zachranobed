import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/common/utils/device_utils.dart';
import 'package:zachranobed/common/utils/firestore_utils.dart';
import 'package:zachranobed/models/dto/entity_dto.dart';

class EntityService {
  final _collection = FirebaseFirestore.instance.collection('entities').withConverter(
    fromFirestore: (snapshot, _) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return EntityDto.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  /// Returns a [Future] that completes with a [EntityDto] object if an entity
  /// document with the provided [email] is found in the Firestore collection
  /// and `null` if no entity is found.
  Future<EntityDto?> getEntityByEmail(String email) async {
    final snapshot = await _collection
        .where(
          'email',
          isEqualTo: email,
        )
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  /// Fetches a list of [EntityDto] objects for the given entity IDs.
  Future<List<EntityDto>> fetchEntities(List<String> ids) => _collection.fetchMultipleDocs(ids);

  Future<void> saveAppTermsVersion(String entityId, int version) async {
    return _collection.doc(entityId).update({'lastAcceptedAppTermsVersion': version});
  }

  /// Stores the given FCM [token] to the entity with ID [entityId] in in the
  /// entities collection. It either updates the FCM token for this device
  /// or creates a new one for this device's ID. If [token] is `null`,
  /// the FCM token for this device is removed.
  Future<void> updateFCMToken(String entityId, String? token) async {
    final deviceId = await DeviceUtils.getId();
    if (deviceId == null) {
      ZOLogger.logMessage("Unable to retrieve device ID");
      return;
    }

    dynamic value;
    if (token != null) {
      value = token;
    } else {
      value = FieldValue.delete();
    }

    // Atomically updates the FCM token of a device under the 'fcmTokens' field of the given entity.
    // If the user is offline, the operation will fail and return an error immediately.
    return FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        final entityRef = _collection.doc(entityId);
        transaction.update(
          entityRef,
          {'fcmTokens.$deviceId': value},
        );
      },
      maxAttempts: 1,
    );
  }
}
