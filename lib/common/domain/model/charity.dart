part of 'user_data.dart';

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
    required super.tags,
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
      tags: tags,
    );
  }

  @override
  FoodBoxesCheckup getFoodBoxesCheckup(EntityPair pair) => pair.recipientFoodBoxesCheckup;

  @override
  bool isManualDonationEnabled(EntityPair pair) => pair.recipientManualDonationEnabled;
}
