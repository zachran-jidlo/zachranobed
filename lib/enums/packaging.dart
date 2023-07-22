import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Packaging {
  reusableBox,
  ikeaBox,
  disposablePackaging,
}

abstract class PackagingHelper {
  static String toValue(Packaging packaging, BuildContext context) {
    switch (packaging) {
      case Packaging.reusableBox:
        return AppLocalizations.of(context)!.packagingRekrabicka;
      case Packaging.ikeaBox:
        return AppLocalizations.of(context)!.packagingIkeaBox;
      case Packaging.disposablePackaging:
        return AppLocalizations.of(context)!.packagingDisposable;
      default:
        return '';
    }
  }
}
