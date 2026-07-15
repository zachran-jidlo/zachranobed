import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/features/banners/data/dto/banner_dto.dart';

/// Reads banners from the `banners` collection.
class BannerService {
  final _collection = FirebaseFirestore.instance //
      .collection('banners')
      .withConverter(
    fromFirestore: (snapshot, _) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return BannerDto.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  /// Observes all active banners. Every other targeting rule (dates, role,
  /// tags, platform, version) is applied client-side.
  Stream<List<BannerDto>> observeActive() {
    return _collection
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
