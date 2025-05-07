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

  /// Observes a list of [NotificationDto] objects for the given [entityId]. Takes only the notifications that
  /// are not older than 7 days.
  ///
  /// This method returns a stream that emits a list of notifications. If [read]
  /// is provided, it filters the notifications based on the read status.
  Stream<List<NotificationDto>> observeNotifications({
    required String entityId,
    bool? read,
  }) {
    final threshold = DateTime.now().subtract(const Duration(days: 7));
    Query<NotificationDto> query = getCollection(entityId)
        .orderBy('timestamp', descending: true)
        .where('timestamp', isGreaterThanOrEqualTo: threshold);

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

  /// Marks all unread notifications as read for the given [entityId].
  Future<void> markAllAsRead({
    required String entityId,
  }) async {
    final collection = getCollection(entityId);

    final querySnapshot = await collection.where('read', isEqualTo: false).get();
    final docs = querySnapshot.docs;

    if (docs.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in docs) {
      batch.update(doc.reference, {'read': true});
    }

    await batch.commit();
  }
}
