import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/dto/contact_dto.dart';

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
  final String responsiblePerson;
  final String? responsiblePersonPosition;
  final String? phone;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final EntityTypeDto? entityType;
  final int? lastAcceptedAppTermsVersion;
  final List<ContactDto>? additionalContacts;

  EntityDto({
    required this.id,
    required this.email,
    required this.establishmentName,
    required this.establishmentId,
    required this.organization,
    required this.responsiblePerson,
    required this.responsiblePersonPosition,
    required this.phone,
    required this.entityType,
    required this.lastAcceptedAppTermsVersion,
    required this.additionalContacts,
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
