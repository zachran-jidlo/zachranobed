import 'package:zachranobed/models/user_data.dart';

class Canteen extends UserData {
  final String pickUpFrom;
  final String pickUpWithin;
  final String recipientId;

  Canteen({
    required super.entityId,
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    required this.pickUpFrom,
    required this.pickUpWithin,
    required this.recipientId,
  });
}
