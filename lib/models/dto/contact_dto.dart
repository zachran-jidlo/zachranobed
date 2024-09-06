import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the contact_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'contact_dto.g.dart';

@JsonSerializable()
class ContactDto {
  final String name;
  final String? position;
  final String? phoneNumber;

  ContactDto({
    required this.name,
    required this.position,
    required this.phoneNumber,
  });

  factory ContactDto.fromJson(Map<String, dynamic> json) =>
      _$ContactDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDtoToJson(this);
}