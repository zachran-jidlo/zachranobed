import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/dto/contact_dto.dart';

/*
 * Command to rebuild the configuration_contacts_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'configuration_contacts_dto.g.dart';

@JsonSerializable()
class ConfigurationContactsDto {
  final List<ContactDto> organisationContacts;

  ConfigurationContactsDto({
    required this.organisationContacts
  });

  factory ConfigurationContactsDto.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationContactsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationContactsDtoToJson(this);
}