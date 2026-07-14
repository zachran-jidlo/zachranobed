import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/common/data/utils/timestamp_converter.dart';

/*
 * Command to rebuild the delivery_pickup_confirmation_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'delivery_pickup_confirmation_dto.g.dart';

/// Per-delivery pickup confirmation state.
@JsonSerializable(explicitToJson: true)
class DeliveryPickupConfirmationDto {
  /// When the recipient confirmed they will pick the donation up. Null until
  /// confirmed.
  @JsonKey(includeIfNull: false)
  @TimestampConverter()
  final DateTime? pickupConfirmedAt;

  DeliveryPickupConfirmationDto({
    required this.pickupConfirmedAt,
  });

  factory DeliveryPickupConfirmationDto.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPickupConfirmationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryPickupConfirmationDtoToJson(this);
}

/// Partial update payload for writing only the `pickupConfirmation` field of a
/// delivery document.
@JsonSerializable(explicitToJson: true, includeIfNull: false, createFactory: false)
class DeliveryPickupConfirmationUpdateDto {
  final DeliveryPickupConfirmationDto? pickupConfirmation;

  DeliveryPickupConfirmationUpdateDto({
    required this.pickupConfirmation,
  });

  Map<String, dynamic> toJson() => _$DeliveryPickupConfirmationUpdateDtoToJson(this);
}
