import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/dto/food_box_pair_dto.dart';
import 'package:zachranobed/models/dto/food_boxes_checkup_dto.dart';
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
  final String carrierId;
  final List<TimeWindowDto> pickupTimeWindows;
  final List<FoodBoxPairDto> foodboxes;
  final FoodBoxesCheckupSummaryDto? foodboxesCheckup;

  EntityPairDto({
    required this.donorId,
    required this.recipientId,
    required this.carrierId,
    required this.pickupTimeWindows,
    required this.foodboxes,
    required this.foodboxesCheckup,
  });

  factory EntityPairDto.fromJson(Map<String, dynamic> json) =>
      _$EntityPairDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EntityPairDtoToJson(this);
}
