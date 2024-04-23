import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the entity.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'entity_dto.g.dart';

@JsonSerializable()
class EntityDto {
  final String id;
  final String email;
  final String establishmentName;
  final String establishmentId;
  final String organization;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final EntityTypeDto? entityType;
  final int? lastAcceptedAppTermsVersion;

  EntityDto({
    required this.id,
    required this.email,
    required this.establishmentName,
    required this.establishmentId,
    required this.organization,
    required this.entityType,
    required this.lastAcceptedAppTermsVersion
  });

  factory EntityDto.fromJson(Map<String, dynamic> json) =>
      _$EntityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EntityDtoToJson(this);
}

enum EntityTypeDto {
  @JsonValue("DONOR")
  donor,
  @JsonValue("RECIPIENT")
  recipient,
}
