import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the user_data.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'user_data.g.dart';

@JsonSerializable()
class UserData extends ChangeNotifier {
  final String email;
  final String pickUpFrom;
  final String pickUpWithin;
  final String establishmentName;
  final String organization;
  final String recipient;

  UserData({
    required this.email,
    required this.pickUpFrom,
    required this.pickUpWithin,
    required this.establishmentName,
    required this.organization,
    required this.recipient,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
