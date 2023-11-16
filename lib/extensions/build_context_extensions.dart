import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  /// Returns the [AppLocalizations] instance associated with the current
  /// [BuildContext].
  AppLocalizations? get l10n => AppLocalizations.of(this);
}
