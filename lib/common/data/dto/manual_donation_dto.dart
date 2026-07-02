import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the manual_donation_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'manual_donation_dto.g.dart';

/// Per-pair configuration for the manual donation entry feature, split by role.
@JsonSerializable(explicitToJson: true)
class ManualDonationSummaryDto {
  final ManualDonationDto? donor;
  final ManualDonationDto? recipient;

  ManualDonationSummaryDto({
    required this.donor,
    required this.recipient,
  });

  factory ManualDonationSummaryDto.fromJson(Map<String, dynamic> json) => _$ManualDonationSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ManualDonationSummaryDtoToJson(this);
}

/// Manual donation entry config for a single role. Stored as a nested map so
/// more options can be added later without another schema change.
@JsonSerializable()
class ManualDonationDto {
  final bool? enabled;

  ManualDonationDto({
    required this.enabled,
  });

  factory ManualDonationDto.fromJson(Map<String, dynamic> json) => _$ManualDonationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ManualDonationDtoToJson(this);
}
