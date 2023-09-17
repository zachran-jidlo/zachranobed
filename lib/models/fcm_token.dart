import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the fcm_token.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'fcm_token.g.dart';

@JsonSerializable()
class FCMToken {
  final String id;
  final String token;

  const FCMToken({required this.id, required this.token});

  factory FCMToken.fromJson(Map<String, dynamic> json) =>
      _$FCMTokenFromJson(json);

  Map<String, dynamic> toJson() => _$FCMTokenToJson(this);
}
