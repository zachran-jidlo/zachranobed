import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'app_terms_config_dto.g.dart';

@JsonSerializable()
class AppTermsConfigDto {
  final int lastVersion;

  AppTermsConfigDto({
    required this.lastVersion,
  });

  factory AppTermsConfigDto.fromJson(Map<String, dynamic> json) =>
      _$AppTermsConfigDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AppTermsConfigDtoToJson(this);
}
