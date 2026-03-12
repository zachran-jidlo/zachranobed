import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/features/faq/data/dto/faq_category_dto.dart';
import 'package:zachranobed/features/faq/data/dto/faq_item_dto.dart';

class FaqService {
  final _contentDoc = FirebaseFirestore.instance.collection('faq').doc('content');

  late final _itemsCollection = _contentDoc //
      .collection('items')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          return FaqItemDto.fromJson(json);
        },
        toFirestore: (value, options) => value.toJson(),
      );

  late final _categoriesCollection = _contentDoc //
      .collection('categories')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          return FaqCategoryDto.fromJson(json);
        },
        toFirestore: (value, options) => value.toJson(),
      );

  Stream<List<QueryDocumentSnapshot<FaqItemDto>>> observeFaqItems() {
    return _itemsCollection.orderBy('order').snapshots().map((snapshot) => snapshot.docs);
  }

  Stream<List<QueryDocumentSnapshot<FaqCategoryDto>>> observeFaqCategories() {
    return _categoriesCollection.orderBy('order').snapshots().map((snapshot) => snapshot.docs);
  }
}
