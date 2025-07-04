import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the box_info.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'box_info.freezed.dart';

@freezed
abstract class BoxInfo with _$BoxInfo {
  const factory BoxInfo({
    String? foodBoxId,
    int? numberOfBoxes,
  }) = _BoxInfo;
}
