import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/common/data/dto/food_box_pair_dto.dart';
import 'package:zachranobed/common/data/dto/food_boxes_checkup_dto.dart';
import 'package:zachranobed/common/data/dto/manual_donation_dto.dart';
import 'package:zachranobed/common/data/dto/pickup_confirmation_dto.dart';
import 'package:zachranobed/common/data/dto/time_window_dto.dart';

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
  final List<TimeWindowDto> deliveryTimeWindows;
  final List<FoodBoxPairDto> foodboxes;
  final FoodBoxesCheckupSummaryDto? foodboxesCheckup;
  final ManualDonationSummaryDto? manualDonation;
  final PickupConfirmationDto? pickupConfirmation;
  final int confirmationTime;

  EntityPairDto({
    required this.donorId,
    required this.recipientId,
    required this.carrierId,
    required this.pickupTimeWindows,
    required this.deliveryTimeWindows,
    required this.foodboxes,
    required this.foodboxesCheckup,
    required this.manualDonation,
    required this.pickupConfirmation,
    required this.confirmationTime,
  });

  factory EntityPairDto.fromJson(Map<String, dynamic> json) => _$EntityPairDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EntityPairDtoToJson(this);
}
