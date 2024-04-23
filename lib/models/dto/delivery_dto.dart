import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/converters/timestamp_converter.dart';
import 'package:zachranobed/models/dto/food_box_delivery_dto.dart';
import 'package:zachranobed/models/dto/meal_dto.dart';

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
  final String carrierId;
  @TimestampConverter()
  final DateTime deliveryDate;
  final List<FoodBoxDeliveryDto> foodBoxes;
  final List<MealDto> meals;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final DeliveryStateDto? state;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final DeliveryTypeDto? type;

  DeliveryDto({
    required this.id,
    required this.donorId,
    required this.recipientId,
    required this.carrierId,
    required this.deliveryDate,
    required this.foodBoxes,
    required this.meals,
    required this.state,
    required this.type,
  });

  factory DeliveryDto.fromJson(Map<String, dynamic> json) =>
      _$DeliveryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryDtoToJson(this);
}

enum DeliveryStateDto {
  @JsonValue("PREPARED")
  prepared,
  @JsonValue("OFFERED")
  offered,
  @JsonValue("ACCEPTED")
  accepted,
  @JsonValue("IN_DELIVERY")
  inDelivery,
  @JsonValue("DELIVERED")
  delivered,
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
