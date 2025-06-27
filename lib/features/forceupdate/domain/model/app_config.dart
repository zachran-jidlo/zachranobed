import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the contacts_summary.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'app_config.freezed.dart';

@freezed
abstract class AppConfig with _$AppConfig {
  const factory AppConfig({
    required String minimumAppVersion,
  }) = $AppConfig;
}
