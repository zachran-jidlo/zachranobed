import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/data/dto/entity_dto.dart';
import 'package:zachranobed/common/data/utils/firestore_utils.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';

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

  /// Stores the given FCM [token] for the [deviceId] under the entity with ID [entityId].
  /// It either updates the FCM token for this device or creates a new one.
  /// If [token] is `null`, the FCM token for this device is removed.
  /// Does nothing if [deviceId] is `null`.
  Future<void> updateFCMToken(String entityId, String? token, String? deviceId) async {
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

  /// Stores device info (app version, build number, platform, last used timestamp)
  /// for the given [deviceId] under the entity with ID [entityId].
  Future<void> updateDeviceInfo(
    String entityId,
    String deviceId,
    String appVersion,
    String appVersionCode,
    String platform,
  ) {
    return _collection.doc(entityId).update({
      'devices.$deviceId': {
        'appVersion': appVersion,
        'appVersionCode': appVersionCode,
        'platform': platform,
        'lastUsed': FieldValue.serverTimestamp(),
      },
    });
  }

  /// Checks if the onboarding for UI changes should be shown for the entity.
  ///
  /// Returns `true` if the `showOnboardingForUiChanges` flag is set to `true`,
  /// otherwise returns `false` (including when the flag is `null` or missing).
  Future<bool> shouldShowOnboardingForUiChanges(String entityId) async {
    final snapshot = await _collection.doc(entityId).get();
    final data = snapshot.data();
    return data?.showOnboardingForUiChanges ?? false;
  }

  /// Removes the `showOnboardingForUiChanges` flag from the entity document.
  Future<void> removeOnboardingForUiChangesFlag(String entityId) {
    return _collection.doc(entityId).update({
      'showOnboardingForUiChanges': FieldValue.delete(),
    });
  }
}
