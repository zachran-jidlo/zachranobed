import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/donor.dart';
import 'package:zachranobed/models/user_data.dart';

/*
 * Command to rebuild the recipient.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'recipient.g.dart';

@JsonSerializable()
class Recipient extends UserData {
  final Donor? donor;

  Recipient({
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    this.donor,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}
