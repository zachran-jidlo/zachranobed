import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/dto/meal_dto.dart';

/*
 * Command to rebuild the delivery_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'delivery_dto.g.dart';

@JsonSerializable()
class DeliveryDto {
  final String donorId;
  final String recipientId;
  final List<MealDto> meals;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final DeliveryStateDto? state;

  DeliveryDto({
    required this.donorId,
    required this.recipientId,
    required this.meals,
    required this.state,
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
