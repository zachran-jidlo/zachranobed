import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/dto/notification_dto.dart';

/// A service class for managing notifications related to a specific entity.
class EntityNotificationService {
  CollectionReference<NotificationDto> getCollection(String entityId) {
    return FirebaseFirestore.instance //
        .collection('entities')
        .doc(entityId)
        .collection('notifications')
        .withConverter(
      fromFirestore: (snapshot, _) {
        final json = snapshot.data() ?? {};
        json['id'] = snapshot.id;
        return NotificationDto.fromJson(json);
      },
      toFirestore: (value, options) {
        final json = value.toJson();
        json.remove('id');
        return json;
      },
    );
  }

  /// Observes a list of [NotificationDto] objects for the given [entityId].
  ///
  /// This method returns a stream that emits a list of notifications. If [read]
  /// is provided, it filters the notifications based on the read status.
  Stream<List<NotificationDto>> observeNotifications({
    required String entityId,
    bool? read,
  }) {
    Query<NotificationDto> query = getCollection(entityId);

    if (read != null) {
      // Add a where clause to filter notifications by read status if provided.
      query = query.where('read', isEqualTo: read);
    }

    return query.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((e) => e.data()).toList();
      },
    );
  }
}
