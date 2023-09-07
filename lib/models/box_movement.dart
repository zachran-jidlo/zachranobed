import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/converters/timestamp_converter.dart';

/*
 * Command to rebuild the box_movement.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'box_movement.g.dart';

@JsonSerializable()
class BoxMovement {
  final String senderId;
  final String recipientId;
  final String boxType;
  final int numberOfBoxes;
  final String weekNumber;
  @TimestampConverter()
  final DateTime date;

  const BoxMovement({
    required this.senderId,
    required this.recipientId,
    required this.boxType,
    required this.numberOfBoxes,
    required this.weekNumber,
    required this.date,
  });

  factory BoxMovement.fromJson(Map<String, dynamic> json) =>
      _$BoxMovementFromJson(json);

  Map<String, dynamic> toJson() => _$BoxMovementToJson(this);
}
