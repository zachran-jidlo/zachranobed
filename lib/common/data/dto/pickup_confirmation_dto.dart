import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the pickup_confirmation_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'pickup_confirmation_dto.g.dart';

/// Per-pair configuration for the pickup confirmation feature.
@JsonSerializable()
class PickupConfirmationDto {
  final bool? enabled;

  PickupConfirmationDto({
    required this.enabled,
  });

  factory PickupConfirmationDto.fromJson(Map<String, dynamic> json) => _$PickupConfirmationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PickupConfirmationDtoToJson(this);
}
