import 'package:json_annotation/json_annotation.dart';
import 'time_window_dto.dart';

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

  EntityPairDto({
    required this.donorId,
    required this.recipientId,
    required this.pickupTimeWindows,
  });

  factory EntityPairDto.fromJson(Map<String, dynamic> json) =>
      _$EntityPairDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EntityPairDtoToJson(this);
}
