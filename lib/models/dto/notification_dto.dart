import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/converters/timestamp_converter.dart';

/*
 * Command to rebuild the notification_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'notification_dto.g.dart';

@JsonSerializable()
class NotificationDto {
  final String id;
  final String title;
  final String message;
  @TimestampConverter()
  final DateTime timestamp;
  final bool read;

  NotificationDto({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);
}
