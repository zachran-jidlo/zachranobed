import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/common/data/utils/timestamp_converter.dart';

/*
 * Command to rebuild the banner_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'banner_dto.g.dart';

@JsonSerializable()
class BannerDto {
  final String id;
  final bool? active;
  final int? priority;
  final String? title;
  final String? text;
  final String? role;
  final String? type;
  @TimestampConverter()
  final DateTime? validFrom;
  @TimestampConverter()
  final DateTime? validTo;
  final List<String>? entityIds;
  final List<String>? tags;
  final List<String>? platforms;
  final String? minAppVersion;
  final String? maxAppVersion;
  final bool? closable;
  final String? actionLabel;
  final String? actionUrl;

  BannerDto({
    required this.id,
    this.active,
    this.priority,
    this.title,
    this.text,
    this.type,
    this.validFrom,
    this.validTo,
    this.role,
    this.entityIds,
    this.tags,
    this.platforms,
    this.minAppVersion,
    this.maxAppVersion,
    this.closable,
    this.actionLabel,
    this.actionUrl,
  });

  factory BannerDto.fromJson(Map<String, dynamic> json) => _$BannerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BannerDtoToJson(this);
}
