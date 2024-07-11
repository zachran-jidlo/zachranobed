import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/common/utils/device_utils.dart';
import 'package:zachranobed/models/dto/entity_dto.dart';

class EntityService {
  final _collection =
      FirebaseFirestore.instance.collection('entities').withConverter(
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

  /// Returns a [Future] that completes with a [EntityDto] object if an entity
  /// document with the provided [entityId] is found in the Firestore collection
  /// and `null` if no entity is found.
  Future<EntityDto?> getEntity(String entityId) {
    return _collection.doc(entityId).get().then((e) => e.data());
  }

  Future<void> saveAppTermsVersion(String entityId, int version) async {
    return _collection
        .doc(entityId)
        .update({'lastAcceptedAppTermsVersion': version});
  }

  /// Stores the given FCM [token] to the entity with ID [entityId] in in the
  /// entities collection. It either updates the FCM token for this device
  /// or creates a new one for this device's ID.
  Future<void> saveFCMToken(String entityId, String? token) async {
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

    return _collection.doc(entityId).update({'fcmTokens.$deviceId': value});
  }
}
