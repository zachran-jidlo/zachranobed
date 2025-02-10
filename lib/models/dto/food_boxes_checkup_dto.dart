import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/converters/timestamp_converter.dart';

/*
 * Command to rebuild the food_boxes_checkup_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'food_boxes_checkup_dto.g.dart';

@JsonSerializable()
class FoodBoxesCheckupSummaryDto {
  final FoodBoxesCheckupDto? donor;
  final FoodBoxesCheckupDto? recipient;

  FoodBoxesCheckupSummaryDto({
    required this.donor,
    required this.recipient,
  });

  factory FoodBoxesCheckupSummaryDto.fromJson(Map<String, dynamic> json) => _$FoodBoxesCheckupSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FoodBoxesCheckupSummaryDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FoodBoxesCheckupDto {
  final FoodBoxesCheckupStatusDto? status;
  @TimestampConverter()
  final DateTime checkAt;
  @TimestampConverter()
  final DateTime? verifiedAt;
  final FoodBoxesCheckupLastChangeDto? lastChange;

  FoodBoxesCheckupDto({
    required this.status,
    required this.checkAt,
    required this.verifiedAt,
    required this.lastChange,
  });

  factory FoodBoxesCheckupDto.fromJson(Map<String, dynamic> json) => _$FoodBoxesCheckupDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FoodBoxesCheckupDtoToJson(this);
}

enum FoodBoxesCheckupStatusDto {
  @JsonValue("OK")
  ok,
  @JsonValue("DELAYED")
  delayed,
  @JsonValue("MISMATCH")
  mismatch;

  String toJson() => _$FoodBoxesCheckupStatusDtoEnumMap[this]!;
}

enum FoodBoxesCheckupLastChangeDto {
  @JsonValue("USER")
  user,
  @JsonValue("ADMIN")
  admin;

  String toJson() => _$FoodBoxesCheckupLastChangeDtoEnumMap[this]!;
}
