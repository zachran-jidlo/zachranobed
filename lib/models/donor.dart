import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the donor.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'donor.g.dart';

@JsonSerializable()
class Donor extends ChangeNotifier {
  final String email;
  final String pickUpFrom;
  final String pickUpWithin;
  final String establishmentName;
  final String establishmentId;
  final String organization;
  final String recipient;

  Donor({
    required this.email,
    required this.pickUpFrom,
    required this.pickUpWithin,
    required this.establishmentName,
    required this.establishmentId,
    required this.organization,
    required this.recipient,
  });

  factory Donor.fromJson(Map<String, dynamic> json) => _$DonorFromJson(json);

  Map<String, dynamic> toJson() => _$DonorToJson(this);
}
