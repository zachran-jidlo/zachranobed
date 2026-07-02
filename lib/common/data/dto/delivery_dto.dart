import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/common/data/dto/food_box_delivery_dto.dart';
import 'package:zachranobed/common/data/dto/meal_dto.dart';
import 'package:zachranobed/common/data/utils/timestamp_converter.dart';

/*
 * Command to rebuild the delivery_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'delivery_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class DeliveryDto {
  final String id;
  final String donorId;
  final String recipientId;
  @TimestampConverter()
  final DateTime deliveryDate;
  final List<FoodBoxDeliveryDto> foodBoxes;
  final List<MealDto> meals;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final DeliveryStateDto? state;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final DeliveryTypeDto? type;
  final int? confirmationTime;
  @JsonKey(includeIfNull: false)
  final bool? foodBoxesTransferred;

  /// Marks a delivery created through the manual donation entry flow (bypassing
  /// the normal delivery process). Such deliveries still appear in history but
  /// are filtered out of the "today's delivery" overview.
  @JsonKey(includeIfNull: false)
  final bool? manualDonation;

  DeliveryDto({
    required this.id,
    required this.donorId,
    required this.recipientId,
    required this.deliveryDate,
    required this.foodBoxes,
    required this.meals,
    required this.state,
    required this.type,
    required this.confirmationTime,
    required this.foodBoxesTransferred,
    this.manualDonation,
  });

  factory DeliveryDto.fromJson(Map<String, dynamic> json) => _$DeliveryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryDtoToJson(this);
}

enum DeliveryStateDto {
  @JsonValue("PREPARED")
  prepared,
  @JsonValue("ACCEPTED")
  accepted,
  @JsonValue("ON_WAY_TO_PICK_UP")
  onWayToPickUp,
  @JsonValue("IN_DELIVERY")
  inDelivery,
  @JsonValue("DELIVERED")
  delivered,
  @JsonValue("DONE")
  done,
  @JsonValue("NOT_USED")
  notUsed;

  String toJson() => _$DeliveryStateDtoEnumMap[this]!;
}

enum DeliveryTypeDto {
  @JsonValue("FOOD_DELIVERY")
  foodDelivery,
  @JsonValue("BOX_DELIVERY")
  boxDelivery;

  String toJson() => _$DeliveryTypeDtoEnumMap[this]!;
}
