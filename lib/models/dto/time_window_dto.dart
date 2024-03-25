import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the time_window_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'time_window_dto.g.dart';

@JsonSerializable()
class TimeWindowDto {

  final String start;
  final String end;

  TimeWindowDto({
    required this.start,
    required this.end,
  });

  factory TimeWindowDto.fromJson(Map<String, dynamic> json) =>
      _$TimeWindowDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TimeWindowDtoToJson(this);
}