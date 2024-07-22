import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/utils/firestore_utils.dart';
import 'package:zachranobed/models/dto/carrier_dto.dart';

class CarrierService {
  final _collection = FirebaseFirestore.instance //
      .collection('carriers')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          return CarrierDto.fromJson(json);
        },
        toFirestore: (value, options) => value.toJson(),
      );

  /// Fetches a list of [CarrierDto] objects for the given entity IDs.
  Future<List<CarrierDto>> fetchCarriers(List<String> ids) =>
      _collection.fetchMultipleDocs(ids);
}
