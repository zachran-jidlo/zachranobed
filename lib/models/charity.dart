import 'package:zachranobed/models/entity_pair.dart';
import 'package:zachranobed/models/user_data.dart';

class Charity extends UserData {
  Charity({
    required super.entityId,
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    required super.lastAcceptedAppTermsVersion,
    required super.activePair,
    required super.hasMultiplePairs,
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
      hasMultiplePairs: hasMultiplePairs,
      activePair: activePair,
    );
  }
}
