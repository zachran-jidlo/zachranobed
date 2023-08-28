import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/recipient.dart';
import 'package:zachranobed/models/user_data.dart';

/*
 * Command to rebuild the donor.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'donor.g.dart';

@JsonSerializable()
class Donor extends UserData {
  final String? pickUpFrom;
  final String? pickUpWithin;
  final Recipient? recipient;

  Donor({
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    this.pickUpFrom,
    this.pickUpWithin,
    this.recipient,
  });

  factory Donor.fromJson(Map<String, dynamic> json) => _$DonorFromJson(json);

  Map<String, dynamic> toJson() => _$DonorToJson(this);
}
