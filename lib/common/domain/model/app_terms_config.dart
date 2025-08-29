import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'app_terms_config.freezed.dart';

/// Represents the configuration for the application's terms and conditions.
@freezed
abstract class AppTermsConfig with _$AppTermsConfig {
  /// Creates an [AppTermsConfig] instance.
  ///
  /// The [lastVersion] parameter represents the latest version of the terms and conditions.
  const factory AppTermsConfig({
    required int lastVersion,
  }) = $AppTermsConfig;
}
