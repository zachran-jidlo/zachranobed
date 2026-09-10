// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_donation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManualDonationSummaryDto _$ManualDonationSummaryDtoFromJson(Map<String, dynamic> json) => ManualDonationSummaryDto(
      donor: json['donor'] == null ? null : ManualDonationDto.fromJson(json['donor'] as Map<String, dynamic>),
      recipient:
          json['recipient'] == null ? null : ManualDonationDto.fromJson(json['recipient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ManualDonationSummaryDtoToJson(ManualDonationSummaryDto instance) => <String, dynamic>{
      'donor': instance.donor?.toJson(),
      'recipient': instance.recipient?.toJson(),
    };

ManualDonationDto _$ManualDonationDtoFromJson(Map<String, dynamic> json) => ManualDonationDto(
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$ManualDonationDtoToJson(ManualDonationDto instance) => <String, dynamic>{
      'enabled': instance.enabled,
    };
