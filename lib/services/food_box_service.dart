import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/dto/food_box_type_dto.dart';

class FoodBoxService {
  final _collection =
      FirebaseFirestore.instance.collection('foodBoxes').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return FoodBoxTypeDto.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  Future<List<FoodBoxTypeDto>> getAll() async {
    final snapshot = await _collection.get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((e) => e.data()).toList();
    }
    return List.empty();
  }
}
