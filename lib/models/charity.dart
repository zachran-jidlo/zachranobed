import 'package:zachranobed/models/user_data.dart';

class Charity extends UserData {
  final List<String>? donorId;

  Charity({
    required super.entityId,
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    required super.lastAcceptedAppTermsVersion,
    this.donorId,
  });
}
