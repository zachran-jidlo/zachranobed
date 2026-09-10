import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';
import 'package:zachranobed/features/banners/data/dto/banner_dto.dart';

/// Reads banners from the `banners` collection.
class BannerService {
  final _collection = FirebaseFirestore.instance.collection('banners').withConverter(
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
  ///
  /// A document that fails to parse is skipped instead of failing the whole
  /// stream, so one malformed banner cannot hide every banner.
  Stream<List<BannerDto>> observeActive() {
    return _collection
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_tryParse).whereType<BannerDto>().toList());
  }

  BannerDto? _tryParse(QueryDocumentSnapshot<BannerDto> doc) {
    try {
      return doc.data();
    } catch (e) {
      ZOLogger.logMessage('Skipping malformed banner ${doc.id}: $e', isError: true);
      return null;
    }
  }
}
