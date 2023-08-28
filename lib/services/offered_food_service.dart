import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/services/helper_service.dart';

class OfferedFoodService {
  final _offeredFoodCollection =
      FirebaseFirestore.instance.collection('nabidka').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return OfferedFood.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  Stream<List<OfferedFood>> loggedUserOfferedFoodStream({
    required BuildContext context,
    int? limit,
    String? additionalFilterField,
    dynamic additionalFilterValue,
  }) {
    var query = _offeredFoodCollection.orderBy('date', descending: true).where(
        Filter.or(
            Filter('donorId',
                isEqualTo:
                    HelperService.getCurrentUser(context)!.establishmentId),
            Filter('recipientId',
                isEqualTo:
                    HelperService.getCurrentUser(context)!.establishmentId)));

    if (limit != null) {
      query = query.limit(limit);
    }

    if (additionalFilterField != null && additionalFilterValue != null) {
      query =
          query.where(additionalFilterField, isEqualTo: additionalFilterValue);
    }

    return query.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  // TODO - z tohodle by bylo fajn nějak udělat stream
  Future<int> getSavedMealsCount(
      {required BuildContext context, int? timePeriod}) async {
    var mealsCount = 0;

    var query = _offeredFoodCollection.where(Filter.or(
        Filter('donorId',
            isEqualTo: HelperService.getCurrentUser(context)!.establishmentId),
        Filter('recipientId',
            isEqualTo:
                HelperService.getCurrentUser(context)!.establishmentId)));

    if (timePeriod != null) {
      query = query.where('date',
          isGreaterThan: DateTime.now().subtract(Duration(days: timePeriod)));
    }

    final querySnapshot = await query.get();

    final donations = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var donation in donations) {
      mealsCount += donation.foodInfo.numberOfServings!;
    }

    return mealsCount;
  }

  Future<DocumentReference<OfferedFood>> createOffer(
      OfferedFood offeredFood) async {
    return await _offeredFoodCollection.add(offeredFood);
  }
}
