import 'package:zachranobed/models/user_data.dart';

class Charity extends UserData {
  final List<String> donorIds;
  final List<String> carrierIds;

  Charity({
    required super.entityId,
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    required super.lastAcceptedAppTermsVersion,
    required this.donorIds,
    required this.carrierIds,
  });
}
