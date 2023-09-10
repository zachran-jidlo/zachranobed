import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/converters/timestamp_converter.dart';

/*
 * Command to rebuild the box_movement.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'box_movement.freezed.dart';
part 'box_movement.g.dart';

@Freezed()
class BoxMovement with _$BoxMovement {
  const factory BoxMovement({
    String? senderId,
    String? recipientId,
    String? boxType,
    int? numberOfBoxes,
    String? weekNumber,
    @TimestampConverter() DateTime? date,
  }) = _BoxMovement;

  factory BoxMovement.fromJson(Map<String, dynamic> json) =>
      _$BoxMovementFromJson(json);
}
