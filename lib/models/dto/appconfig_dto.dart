import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the contact_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'appconfig_dto.g.dart';

@JsonSerializable()
class AppConfigDto {
  final String minimumAppVersion;

  AppConfigDto({
    required this.minimumAppVersion,
  });

  factory AppConfigDto.fromJson(Map<String, dynamic> json) =>
      _$AppConfigDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigDtoToJson(this);
}
