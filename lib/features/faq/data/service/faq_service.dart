import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/features/faq/data/dto/faq_item_dto.dart';

class FaqService {
  final _collection = FirebaseFirestore.instance //
      .collection('faq')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          return FaqItemDto.fromJson(json);
        },
        toFirestore: (value, options) => value.toJson(),
      );

  Stream<List<QueryDocumentSnapshot<FaqItemDto>>> observeFaqItems() {
    return _collection.orderBy('order').snapshots().map((snapshot) => snapshot.docs);
  }
}
