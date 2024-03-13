import 'package:zachranobed/models/user_data.dart';

class Canteen extends UserData {
  final String? pickUpFrom;
  final String? pickUpWithin;
  final String? recipientId;

  Canteen({
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    this.pickUpFrom,
    this.pickUpWithin,
    this.recipientId,
  });
}
