import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';

/*
 * Command to rebuild the recipient.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'recipient.g.dart';

@JsonSerializable()
class Recipient extends UserNotifier {
  final String email;
  final String establishmentName;
  final String establishmentId;
  final String organization;
  final List<String> donor;

  Recipient({
    required this.email,
    required this.establishmentName,
    required this.establishmentId,
    required this.organization,
    required this.donor,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}
