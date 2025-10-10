import 'package:zachranobed/common/domain/model/entity_pair.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';

class Charity extends UserData {
  Charity({
    required super.entityId,
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    required super.lastAcceptedAppTermsVersion,
    required super.activePair,
    required super.allPairs,
  });

  @override
  UserData copyWith({required EntityPair activePair}) {
    return Charity(
      entityId: entityId,
      email: email,
      establishmentName: establishmentName,
      establishmentId: establishmentId,
      organization: organization,
      lastAcceptedAppTermsVersion: lastAcceptedAppTermsVersion,
      allPairs: allPairs,
      activePair: activePair,
    );
  }

  @override
  FoodBoxesCheckup getFoodBoxesCheckup(EntityPair pair) => pair.recipientFoodBoxesCheckup;
}
