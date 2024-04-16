import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the remote_app_configuration_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'remote_app_configuration_dto.g.dart';

@JsonSerializable()
class RemoteAppConfigurationDto {
  final int lastAppTermsVersion;

  RemoteAppConfigurationDto({
    required this.lastAppTermsVersion
  });

  factory RemoteAppConfigurationDto.fromJson(Map<String, dynamic> json) =>
      _$RemoteAppConfigurationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteAppConfigurationDtoToJson(this);
}