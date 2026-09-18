import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/common/data/dto/contact_dto.dart';

/*
 * Command to rebuild the paired_entity_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'paired_entity_dto.g.dart';

/// Contact data of an entity, as returned by the `getPairedEntities` function.
///
/// Deliberately narrower than the entity document. The function whitelists the
/// fields it returns, so this type cannot carry anything a paired counterparty
/// is not meant to see.
@JsonSerializable()
class PairedEntityDto {
  final String id;
  final String establishmentName;
  final String responsiblePerson;
  final String? responsiblePersonPosition;
  final String? phone;
  final List<ContactDto>? additionalContacts;

  PairedEntityDto({
    required this.id,
    required this.establishmentName,
    required this.responsiblePerson,
    required this.responsiblePersonPosition,
    required this.phone,
    required this.additionalContacts,
  });

  factory PairedEntityDto.fromJson(Map<String, dynamic> json) => _$PairedEntityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PairedEntityDtoToJson(this);
}
