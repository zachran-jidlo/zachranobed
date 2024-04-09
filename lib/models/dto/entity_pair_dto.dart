import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/dto/food_box_pair_dto.dart';
import 'package:zachranobed/models/dto/time_window_dto.dart';

/*
 * Command to rebuild the entity_pair.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'entity_pair_dto.g.dart';

@JsonSerializable()
class EntityPairDto {
  final String donorId;
  final String recipientId;
  final List<TimeWindowDto> pickupTimeWindows;
  final List<FoodBoxPairDto> foodboxes;

  EntityPairDto({
    required this.donorId,
    required this.recipientId,
    required this.pickupTimeWindows,
    required this.foodboxes,
  });

  factory EntityPairDto.fromJson(Map<String, dynamic> json) =>
      _$EntityPairDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EntityPairDtoToJson(this);
}
